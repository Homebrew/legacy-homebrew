$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://xmlrpc-c.sourceforge.net/'
url='http://kent.dl.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.06.33.tgz'
md5='7dda4d8c5d26ae877d3809e428ce7962'

Formula.new(url, md5).brew do |prefix|
  # choosing --enable-libxml2-backend to lose some weight and not statically
  # link in expat
  #NOTE seemingly it isn't possible to build dylibs with this thing
  system "./configure --disable-debug --enable-libxml2-backend --prefix='#{prefix}'"
  system "make"
  system "make install"
end