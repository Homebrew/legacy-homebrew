module CompilerConstants
  GNU_GCC_VERSIONS = 3..9
  GNU_GCC_REGEXP = /^gcc-(4\.[3-9])$/
end

class Compiler < Struct.new(:name, :version, :priority)
  # The major version for non-Apple compilers. Used to indicate a compiler
  # series; for instance, if the version is 4.8.2, it would return "4.8".
  def major_version
    version.match(/(\d\.\d)/)[0] if name.is_a? String
  end
end

class CompilerFailure
  attr_reader :name
  attr_rw :cause, :version

  # Allows Apple compiler `fails_with` statements to keep using `build`
  # even though `build` and `version` are the same internally
  alias_method :build, :version

  def self.for_standard standard
    COLLECTIONS.fetch(standard) do
      raise ArgumentError, "\"#{standard}\" is not a recognized standard"
    end
  end

  def self.create(spec, &block)
    # Non-Apple compilers are in the format fails_with compiler => version
    if spec.is_a?(Hash)
      _, major_version = spec.first
      name = "gcc-#{major_version}"
      # so fails_with :gcc => '4.8' simply marks all 4.8 releases incompatible
      version = "#{major_version}.999"
      GnuCompilerFailure.new(name, major_version, version, &block)
    else
      name = spec
      version = 9999
      new(name, version, &block)
    end
  end

  def initialize(name, version, &block)
    @name = name
    @version = version
    instance_eval(&block) if block_given?
  end

  def ===(compiler)
    name == compiler.name && version >= (compiler.version || 0)
  end

  class GnuCompilerFailure < CompilerFailure
    attr_reader :major_version

    def initialize(name, major_version, version, &block)
      @major_version = major_version
      super(name, version, &block)
    end

    def ===(compiler)
      super && major_version == compiler.major_version
    end
  end

  MESSAGES = {
    :cxx11 => "This compiler does not support C++11"
  }

  cxx11 = proc { cause MESSAGES[:cxx11] }

  COLLECTIONS = {
    :cxx11 => [
      create(:gcc_4_0, &cxx11),
      create(:gcc, &cxx11),
      create(:llvm, &cxx11),
      create(:clang) { build 425; cause MESSAGES[:cxx11] },
      create(:gcc => "4.3", &cxx11),
      create(:gcc => "4.4", &cxx11),
      create(:gcc => "4.5", &cxx11),
      create(:gcc => "4.6", &cxx11),
    ],
    :openmp => [
      create(:clang) { cause "clang does not support OpenMP" },
    ]
  }
end

class CompilerQueue
  def initialize
    @array = []
  end

  def <<(o)
    @array << o
    self
  end

  def pop
    @array.delete(@array.max { |a, b| a.priority <=> b.priority })
  end

  def empty?
    @array.empty?
  end
end

class CompilerSelector
  def initialize(f, versions=MacOS)
    @f = f
    @versions = versions
    @compilers = CompilerQueue.new
    %w{clang llvm gcc gcc_4_0}.map(&:to_sym).each do |cc|
      version = @versions.send("#{cc}_build_version")
      unless version.nil?
        @compilers << Compiler.new(cc, version, priority_for(cc))
      end
    end

    # non-Apple GCC 4.x
    CompilerConstants::GNU_GCC_VERSIONS.each do |v|
      name = "gcc-4.#{v}"
      version = @versions.non_apple_gcc_version(name)
      unless version.nil?
        # priority is based on version, with newest preferred first
        @compilers << Compiler.new(name, version, 1.0 + v/10.0)
      end
    end
  end

  # Attempts to select an appropriate alternate compiler, but
  # if none can be found raises CompilerError instead
  def compiler
    while cc = @compilers.pop
      return cc.name unless @f.fails_with?(cc)
    end
    raise CompilerSelectionError.new(@f)
  end

  private

  def priority_for(cc)
    case cc
    when :clang then @versions.clang_build_version >= 318 ? 3 : 0.5
    when :gcc   then 2.5
    when :llvm  then 2
    when :gcc_4_0 then 0.25
    # non-Apple gcc compilers
    else 1.5
    end
  end
end
