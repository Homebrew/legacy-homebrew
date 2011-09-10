require 'formula'

class Libjpeg < Formula
  url 'http://www.ijg.org/files/jpegsrc.v8c.tar.gz'
  homepage 'http://www.ijg.org/'
  sha1 'f0a3b88ac4db19667798bee971537eeed552bce9'
  version "8c"
  # depends_on 'cmake'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end


