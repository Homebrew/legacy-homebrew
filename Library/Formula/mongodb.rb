require 'formula'
require 'hardware'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit? and not ARGV.include? '--32bit'
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.1.4.tgz'
    md5 '77744c7cd163c3c10b4763a59f20561e'
    version '1.1.4-x86_64'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.1.4.tgz'
    md5 '4b6cbcccf10fa6e65b6450f9b098cb27'
    version '1.1.4-i386'
  end
  
  def skip_clean? path
    true
  end

  def install
    system "cp -prv * #{prefix}"
  end
end
