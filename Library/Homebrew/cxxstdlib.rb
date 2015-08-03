require "compilers"

class CxxStdlib
  include CompilerConstants

  class CompatibilityError < StandardError
    def initialize(formula, dep, stdlib)
      super <<-EOS.undent
        #{formula.full_name} dependency #{dep.name} was built with a different C++ standard
        library (#{stdlib.type_string} from #{stdlib.compiler}). This may cause problems at runtime.
        EOS
    end
  end

  def self.create(type, compiler)
    if type && ![:libstdcxx, :libcxx].include?(type)
      raise ArgumentError, "Invalid C++ stdlib type: #{type}"
    end
    klass = GNU_GCC_REGEXP === compiler.to_s ? GnuStdlib : AppleStdlib
    klass.new(type, compiler)
  end

  def self.check_compatibility(formula, deps, keg, compiler)
    return if formula.skip_cxxstdlib_check?

    stdlib = create(keg.detect_cxx_stdlibs.first, compiler)

    begin
      stdlib.check_dependencies(formula, deps)
    rescue CompatibilityError => e
      opoo e.message
    end
  end

  attr_reader :type, :compiler

  def initialize(type, compiler)
    @type = type
    @compiler = compiler.to_sym
  end

  # If either package doesn't use C++, all is well
  # libstdc++ and libc++ aren't ever intercompatible
  # libstdc++ is compatible across Apple compilers, but
  # not between Apple and GNU compilers, or between GNU compiler versions
  def compatible_with?(other)
    return true if type.nil? || other.type.nil?

    return false unless type == other.type

    apple_compiler? && other.apple_compiler? ||
      !other.apple_compiler? && compiler.to_s[4..6] == other.compiler.to_s[4..6]
  end

  def check_dependencies(formula, deps)
    deps.each do |dep|
      # Software is unlikely to link against libraries from build-time deps, so
      # it doesn't matter if they link against different C++ stdlibs.
      next if dep.build?

      dep_stdlib = Tab.for_formula(dep.to_formula).cxxstdlib
      unless compatible_with? dep_stdlib
        raise CompatibilityError.new(formula, dep, dep_stdlib)
      end
    end
  end

  def type_string
    type.to_s.gsub(/cxx$/, "c++")
  end

  def inspect
    "#<#{self.class.name}: #{compiler} #{type}>"
  end

  class AppleStdlib < CxxStdlib
    def apple_compiler?
      true
    end
  end

  class GnuStdlib < CxxStdlib
    def apple_compiler?
      false
    end
  end
end
