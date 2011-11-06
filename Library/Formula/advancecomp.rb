require 'formula'

class Advancecomp < Formula
  url 'http://downloads.sourceforge.net/advancemame/advancecomp-1.15.tar.gz'
  md5 'bb236d8bee6fa473d34108cda1e09076'
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
