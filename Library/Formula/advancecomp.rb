require 'formula'

class Advancecomp < Formula
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'
  url 'http://downloads.sourceforge.net/advancemame/advancecomp-1.15.tar.gz'
  sha1 '74fed754841efadcb8dd156d2c5e095bfaff83e6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
