require 'formula'

class Jpeg <Formula
  url 'http://www.ijg.org/files/jpegsrc.v8b.tar.gz'
  version '8b'
  md5 'e022acbc5b36cd2cb70785f5b575661e'
  homepage 'http://www.ijg.org'

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
