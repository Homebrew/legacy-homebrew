$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://lame.sourceforge.net/'
url='http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz'
md5='719dae0ee675d0c16e0e89952930ed35'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}' --enable-nasm"
  system "make install" # if this fails, split into two steps
end