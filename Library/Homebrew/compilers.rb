class Compiler < Struct.new(:name, :priority)
  def build
    MacOS.send("#{name}_build_version")
  end

  def version
    MacOS.non_apple_gcc_version(name) if name.is_a? String
  end
end

class CompilerFailure
  attr_reader :compiler, :version
  attr_rw :build, :cause

  def initialize compiler, &block
    # Non-Apple compilers are in the format fails_with compiler => version
    if compiler.is_a? Hash
      # currently the only compiler for this case is GCC
      _, @version = compiler.shift
      @compiler = 'gcc-' + @version.match(/(\d\.\d)/)[0]
    else
      @compiler = compiler
    end

    instance_eval(&block) if block_given?
    @build = (@build || 9999).to_i unless compiler.is_a? Hash
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
  def initialize(f)
    @f = f
    @compilers = CompilerQueue.new
    %w{clang llvm gcc gcc_4_0}.map(&:to_sym).each do |cc|
      unless MacOS.send("#{cc}_build_version").nil?
        @compilers << Compiler.new(cc, priority_for(cc))
      end
    end

    # non-Apple GCC 4.x
    SharedEnvExtension::GNU_GCC_VERSIONS.each do |v|
      unless MacOS.non_apple_gcc_version("gcc-4.#{v}").nil?
        # priority is based on version, with newest preferred first
        @compilers << Compiler.new("gcc-4.#{v}", 1.0 + v/10.0)
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
      raise CompilerSelectionError
    else
      cc.name
    end
  end

  private

  def priority_for(cc)
    case cc
    when :clang then MacOS.clang_build_version >= 318 ? 3 : 0.5
    when :gcc   then 2.5
    when :llvm  then 2
    when :gcc_4_0 then 0.25
    # non-Apple gcc compilers
    else 1.5
    end
  end
end
