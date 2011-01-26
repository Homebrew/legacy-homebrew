require 'formula'

class Jpeg <Formula
  url 'http://www.ijg.org/files/jpegsrc.v8c.tar.gz'
  version '8c'
  sha256 'edfc0b3e004b2fe58ffeeec89f96e3a3c28972c46725ec127d01edf8a1cc7c9a'
  homepage 'http://www.ijg.org'

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
