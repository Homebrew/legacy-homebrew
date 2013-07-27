class CxxStdlib
  attr_accessor :type, :compiler

  def initialize(type, compiler)
    if ![:libstdcxx, :libcxx].include? type
      raise ArgumentError, "Invalid C++ stdlib type: #{type}"
    end

    @type     = type.to_sym
    @compiler = compiler.to_sym
  end

  def apple_compiler?
    not compiler.to_s =~ SharedEnvExtension::GNU_GCC_REGEXP
  end

  def compatible_with?(other)
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

  def type_string
    type.to_s.gsub(/cxx$/, 'c++')
  end
end
