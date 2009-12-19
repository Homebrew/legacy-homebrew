require 'formula'
require 'hardware'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit? and not ARGV.include? '--32bit'
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.2.0.tgz'
    md5 'e2d6f7b7f1c0ab71fd629c015ced033c'
    version '1.2.0-x86_64'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.2.0.tgz'
    md5 'e85c3e4bdf910ece0e47f85885b78219'
    version '1.2.0-i386'
  end
  
  def skip_clean? path
    true
  end

  def install
    system "cp -prv * #{prefix}"
  end
end
