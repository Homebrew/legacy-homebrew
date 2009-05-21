$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.underbit.com/products/mad/'
url='http://kent.dl.sourceforge.net/sourceforge/mad/libmad-0.15.1b.tar.gz'
md5='1be543bc30c56fb6bea1d7bf6a64e66c'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debugging --enable-fpm=intel --prefix='#{prefix}'"
  system "make"
  system "make install"
end