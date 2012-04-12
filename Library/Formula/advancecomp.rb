require 'formula'

class Advancecomp < Formula
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'
  url 'http://downloads.sourceforge.net/advancemame/advancecomp-1.15.tar.gz'
  md5 'bb236d8bee6fa473d34108cda1e09076'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
