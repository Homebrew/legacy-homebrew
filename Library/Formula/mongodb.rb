require 'formula'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit? and not ARGV.include? '--32bit'
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.1.2.tgz'
    md5 '7fdcd8173fa975295b961e760eed1751'
    version '1.1.2-x86_64'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.1.2.tgz'
    md5 '0e10467e2a0877d189e4d4c0783ebc4b'
    version '1.1.2-i386'
  end
  
  def skip_clean? path
    true
  end

  def install
    system "cp -prv * #{prefix}"
  end
end
