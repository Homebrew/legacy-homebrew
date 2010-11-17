require 'formula'

class Fantom <Formula
  url 'http://fan.googlecode.com/files/fantom-1.0.56.zip'
  homepage 'http://fantom.org/'
  md5 'a67e9ce7e687cb9f003f695baad6b7e6'

  def doc
    prefix+'share/doc/fantom'
  end

  def install
    prefix.install Dir['*']
  end
end
