require 'formula'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit?
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.1.2.tgz'
    md5 '7fdcd8173fa975295b961e760eed1751'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.1.2.tgz'
    md5 '0e10467e2a0877d189e4d4c0783ebc4b'
  end

  def install
    system "cp -prv * #{prefix}"
  end
end
