$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'
require 'fileutils'

homepage='http://betterthangrep.com/'

class AckFormula < UncompressedScriptFormula
  def initialize
    super('http://ack.googlecode.com/svn/tags/1.88/ack')
    @version='1.88'
    @md5='8009a13ab0fc66047bea0ea2ad89419c'
  end
end

ack=AckFormula.new
ack.brew do |prefix|
  bin=prefix+'bin'
  bin.mkpath
  FileUtils.cp ack.name, bin
  (bin+ack.name).chmod 0544
  nil
end