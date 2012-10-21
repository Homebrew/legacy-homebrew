require 'formula'

class Ctail < Formula
  homepage 'http://ctail.i-want-a-pony.com/'
  url 'http://ctail.i-want-a-pony.com/downloads/ctail-0.1.0.tar.bz2'
  sha1 '4bd0373df88136b48cac721c98d34cefda27aff9'

  depends_on :automake
  depends_on :libtool

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system 'make'
    system 'make install'
  end
end
