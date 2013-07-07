require 'formula'

class Advancecomp < Formula
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'
  url 'http://downloads.sourceforge.net/advancemame/advancecomp-1.17.tar.gz'
  sha1 '9197bc424d111575501221710301b44764150e85'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
