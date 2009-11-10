require 'formula'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit? and not ARGV.include? '--32bit'
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.1.3.tgz'
    md5 '3d0d84de2e9c826c597b8b22f752ff71'
    version '1.1.3-x86_64'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.1.3.tgz'
    md5 '8df71bdc8e127ee16db3ddd0fa748cf3'
    version '1.1.3-i386'
  end
  
  def skip_clean? path
    true
  end

  def install
    system "cp -prv * #{prefix}"
  end
end
