$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://pmt.sourceforge.net/pngcrush/'
url='http://kent.dl.sourceforge.net/sourceforge/pmt/pngcrush-1.6.17.tar.bz2'
md5='8ba31ae9b1b14e7648df320fd1ed27c7'

Formula.new(url, md5).brew do |prefix|
  system "make"
  bin=prefix+'bin'
  bin.mkpath
  FileUtils.cp 'pngcrush', bin
end