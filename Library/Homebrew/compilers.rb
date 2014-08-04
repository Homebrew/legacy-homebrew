module CompilerConstants
  GNU_GCC_VERSIONS = 3..9
  GNU_GCC_REGEXP = /^gcc-(4\.[3-9])$/
end

# TODO make this class private to CompilerSelector
class Compiler
  attr_reader :name, :version, :priority

  def initialize(name, version=0, priority=0)
    @name = name
    @version = version
    @priority = priority
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
    else
      name = spec
      version = 9999
    end
    new(name, version, &block)
  end

  def initialize(name, version, &block)
    @name = name
    @version = version
    instance_eval(&block) if block_given?
  end

  def ===(compiler)
    name == compiler.name && version >= compiler.version
  end

  def inspect
    "#<#{self.class.name}: #{name} #{version}>"
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
    when :clang   then @versions.clang_build_version >= 318 ? 3 : 0.5
    when :gcc     then 2.5
    when :llvm    then 2
    when :gcc_4_0 then 0.25
    end
  end
end
