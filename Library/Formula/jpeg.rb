require 'formula'

class Jpeg <Formula
  url 'http://www.ijg.org/files/jpegsrc.v8c.tar.gz'
  version '8c'
  md5 'a2c10c04f396a9ce72894beb18b4e1f9'
  homepage 'http://www.ijg.org'

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
