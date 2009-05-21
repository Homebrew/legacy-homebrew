$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'
require 'fileutils'

homepage='http://betterthangrep.com/'

class UncompressedFormula < Formula
  def initialize
    @name='ack'
    @version='1.88'
    @url='http://ack.googlecode.com/svn/tags/1.88/ack'
    @md5='8009a13ab0fc66047bea0ea2ad89419c'
  end

  def uncompress path
    path.dirname
  end
end

UncompressedFormula.new.brew do |prefix|
  bin=prefix+'bin'
  FileUtils.mkpath bin
  FileUtils.cp 'ack', bin
end