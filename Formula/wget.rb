$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.gnu.org/software/wget/'
url='http://ftp.gnu.org/gnu/wget/wget-1.11.4.tar.bz2'
md5='f5076a8c2ec2b7f334cb6e3059820f9c'

Formula.new(url, md5).brew do |prefix|
  `./configure --disable-debug --prefix="#{prefix}"`
  `make`
  `make install`
end