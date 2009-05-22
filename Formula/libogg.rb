$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.xiph.org/ogg/'
url='http://downloads.xiph.org/releases/ogg/libogg-1.1.3.tar.gz'
md5='eaf7dc6ebbff30975de7527a80831585'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}'"
  system "make install"
end