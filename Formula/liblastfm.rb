$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://github.com/mxcl/liblastfm/'
url='http://github.com/mxcl/liblastfm/tarball/0.3.0'
md5='b348917689b90f3f40125d0968f0b643'

external_deps=['qmake']

Formula.new(url, md5).brew do |prefix|
  system "./configure --release --prefix '#{prefix}'"
  system "make"
  system "make install"
end