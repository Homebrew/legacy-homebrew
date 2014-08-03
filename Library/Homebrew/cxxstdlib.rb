require "compilers"

class CxxStdlib
  include CompilerConstants

  def self.create(type, compiler)
    if type && ![:libstdcxx, :libcxx].include?(type)
      raise ArgumentError, "Invalid C++ stdlib type: #{type}"
    end
    klass = GNU_GCC_REGEXP === compiler.to_s ? GnuStdlib : AppleStdlib
    klass.new(type, compiler)
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
    unless formula.skip_cxxstdlib_check?
      deps.each do |dep|
        # Software is unlikely to link against anything from its
        # buildtime deps, so it doesn't matter at all if they link
        # against different C++ stdlibs
        next if dep.build?

        dep_stdlib = Tab.for_formula(dep.to_formula).cxxstdlib
        if !compatible_with? dep_stdlib
          raise IncompatibleCxxStdlibs.new(formula, dep, dep_stdlib, self)
        end
      end
    end
  end

  def type_string
    type.to_s.gsub(/cxx$/, 'c++')
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
