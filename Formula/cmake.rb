$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

url='http://www.cmake.org/files/v2.6/cmake-2.6.3.tar.gz'
md5='5ba47a94ce276f326abca1fd72a7e7c6'

Formula.new(url, md5).brew do |prefix|
  system "./bootstrap --prefix=#{prefix} --system-libs"
  system "make"
  system "make install"
end