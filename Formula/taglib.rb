$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://developer.kde.org/~wheeler/taglib.html'
url='http://developer.kde.org/~wheeler/files/src/taglib-1.5.tar.gz'
md5='7b557dde7425c6deb7bbedd65b4f2717'

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}'"
  system "make"
  system "make install"
end