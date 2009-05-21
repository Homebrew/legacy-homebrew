$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://git-scm.com'
url='http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2'
md5='c1f4aab741359c29f0fbf28563ac7387'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}'"
  system "make"
  system "make install"
end