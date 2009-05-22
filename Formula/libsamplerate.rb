$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.mega-nerd.com/SRC'
url='http://www.mega-nerd.com/SRC/libsamplerate-0.1.7.tar.gz'
md5='ad093e60ec44f0a60de8e29983ddbc0f'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}'"
  system "make install"
end