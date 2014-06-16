class Compiler < Struct.new(:name, :version, :priority)
  # The major version for non-Apple compilers. Used to indicate a compiler
  # series; for instance, if the version is 4.8.2, it would return "4.8".
  def major_version
    version.match(/(\d\.\d)/)[0] if name.is_a? String
  end
end

class CompilerFailure
  attr_reader :compiler, :major_version
  attr_rw :cause, :version

  # Allows Apple compiler `fails_with` statements to keep using `build`
  # even though `build` and `version` are the same internally
  alias_method :build, :version

  MESSAGES = {
    :cxx11 => 'This compiler does not support C++11'
  }

  COLLECTIONS = {
    :cxx11 => [
      [:gcc_4_0, proc { cause MESSAGES[:cxx11] }],
      [:gcc, proc { cause MESSAGES[:cxx11] }],
      [:llvm, proc { cause MESSAGES[:cxx11] }],
      [:clang, proc { build 425; cause MESSAGES[:cxx11] }],
      [{:gcc => '4.3'}, proc { cause MESSAGES[:cxx11] }],
      [{:gcc => '4.4'}, proc { cause MESSAGES[:cxx11] }],
      [{:gcc => '4.5'}, proc { cause MESSAGES[:cxx11] }],
      [{:gcc => '4.6'}, proc { cause MESSAGES[:cxx11] }]
    ],
    :openmp => [
      [:clang, proc { cause 'clang does not support OpenMP' }]
    ]
  }

  def self.for_standard standard
    failures = COLLECTIONS.fetch(standard) do
      raise ArgumentError, "\"#{standard}\" is not a recognized standard"
    end

    failures.map do |compiler, block|
      CompilerFailure.new(compiler, &block)
    end
  end

  def initialize compiler, &block
    instance_eval(&block) if block_given?
    # Non-Apple compilers are in the format fails_with compiler => version
    if compiler.is_a? Hash
      # currently the only compiler for this case is GCC
      _, @major_version = compiler.first
      @compiler = 'gcc-' + @major_version
      # so fails_with :gcc => '4.8' simply marks all 4.8 releases incompatible
      @version ||= @major_version + '.999'
    else
      @compiler = compiler
      @version ||= 9999
      @version = @version.to_i
    end
  end
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
    SharedEnvExtension::GNU_GCC_VERSIONS.each do |v|
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
    begin
      cc = @compilers.pop
    end while @f.fails_with?(cc)

    if cc.nil?
      raise CompilerSelectionError.new(@f)
    else
      cc.name
    end
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
