$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.boost.org'
url='http://kent.dl.sourceforge.net/sourceforge/boost/boost_1_39_0.tar.bz2'
md5='a17281fd88c48e0d866e1a12deecbcc0'

Formula.new(url, md5).brew do |prefix|
  lib=prefix+'lib'
  # we specify libdir too because the script is apparently broken
  
  #TODO we can save 6300 links if we just had the intelligence to symlink the
  # include/boost dir and not more
  
  system "./bootstrap.sh --prefix='#{prefix}' --libdir='#{lib}'"
  system "./bjam --layout=system --prefix='#{prefix}' --libdir='#{lib}' install"
end