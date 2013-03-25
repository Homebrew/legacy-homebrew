class Compiler < Struct.new(:name, :priority)
  def build
    case name
    when :clang, :llvm
      MacOS.send("#{name}_build_version")
    when :gcc
      MacOS.gcc_42_build_version
    end
  end
end

class CompilerFailure
  attr_reader :compiler

  def initialize compiler, &block
    @compiler = compiler
    instance_eval(&block) if block_given?
    @build ||= 9999
  end

  def build val=nil
    val.nil? ? @build.to_i : @build = val.to_i
  end

  def cause val=nil
    val.nil? ? @cause : @cause = val
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
  def initialize(f, old_compiler=ENV.compiler)
    @f = f
    @old_compiler = old_compiler
    @compilers = CompilerQueue.new
    %w{clang llvm gcc}.map(&:to_sym).each do |cc|
      @compilers << Compiler.new(cc, priority_for(cc))
    end
  end

  def compiler
    begin
      cc = @compilers.pop
    end while @f.fails_with?(cc)
    cc.nil? ? @old_compiler : cc.name
  end

  private

  def priority_for(cc)
    case cc
    when :clang then MacOS.clang_build_version >= 211 ? 3 : 0.5
    when :llvm  then 2
    when :gcc   then 1
    end
  end
end
