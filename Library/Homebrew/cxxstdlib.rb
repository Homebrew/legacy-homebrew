class CxxStdlib
  attr_accessor :type, :compiler

  def initialize(type, compiler)
    if type && ![:libstdcxx, :libcxx].include?(type)
      raise ArgumentError, "Invalid C++ stdlib type: #{type}"
    end

    @type     = type.to_sym if type
    @compiler = compiler.to_sym
  end

  def apple_compiler?
    not compiler.to_s =~ SharedEnvExtension::GNU_GCC_REGEXP
  end

  def compatible_with?(other)
    # If either package doesn't use C++, all is well
    return true if type.nil? || other.type.nil?

    # libstdc++ and libc++ aren't ever intercompatible
    return false unless type == other.type

    # libstdc++ is compatible across Apple compilers, but
    # not between Apple and GNU compilers, or between GNU compiler versions
    return false if apple_compiler? && !other.apple_compiler?
    if compiler.to_s =~ SharedEnvExtension::GNU_GCC_REGEXP
      return false unless other.compiler.to_s =~ SharedEnvExtension::GNU_GCC_REGEXP
      return false unless compiler.to_s[4..6] == other.compiler.to_s[4..6]
    end

    true
  end

  def check_dependencies(formula, deps)
    unless formula.class.cxxstdlib.include? :skip
      deps.each do |dep|
        # Software is unlikely to link against anything from its
        # buildtime deps, so it doesn't matter at all if they link
        # against different C++ stdlibs
        next if dep.tags.include? :build

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
end
