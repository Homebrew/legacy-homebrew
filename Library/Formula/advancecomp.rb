require 'formula'

class Advancecomp < Formula
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'
  url 'https://downloads.sourceforge.net/advancemame/advancecomp-1.18.tar.gz'
  sha1 'e5b00dc75cd6db4dfb1886968baf26a3a450ef7e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
