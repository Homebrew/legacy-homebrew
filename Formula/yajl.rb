$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://lloyd.github.com/yajl/'
url='http://github.com/lloyd/yajl/tarball/1.0.5'
md5='f4a3cbc764c43231ed1aedc54438b69b'

deps=['cmake']

Formula.new(url, md5).brew do |prefix|
  
  inreplace 'configure', 'cmake \.\.', "cmake -DCMAKE_INSTALL_PREFIX='#{prefix}' \.\."
  
  system "./configure --prefix '#{prefix}'"
  system "make install"
end