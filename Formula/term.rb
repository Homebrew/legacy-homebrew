$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'
require 'fileutils'

homepage='http://gist.github.com/116587'

class TermFormula < UncompressedScriptFormula
  def initialize
    super('http://github.com/liyanage/macosx-shell-scripts/raw/e29f7eaa1eb13d78056dec85dc517626ab1d93e3/term')
    @md5='1bbf4509a50224b27ac8c20d3fe8682e'
    @version='2.1'
  end
end

term=TermFormula.new
term.brew do |prefix|
  bin=(prefix+'bin')
  bin.mkpath
  FileUtils.cp term.name, bin
  nil
end