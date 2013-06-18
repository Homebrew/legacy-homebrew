class Compiler < Struct.new(:name, :priority)
  def build
    MacOS.send("#{name}_build_version")
  end
end

class CompilerFailure
  attr_reader :compiler
  attr_rw :build, :cause

  def initialize compiler, &block
    @compiler = compiler
    instance_eval(&block) if block_given?
    @build = (@build || 9999).to_i
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
    when :llvm  then 2
    when :gcc   then 1
    when :gcc_4_0 then 0.25
    end
  end
end
