require 'formula'

class Mboxgrep < Formula
  homepage "http://www.mboxgrep.org"
  url "http://downloads.sourceforge.net/project/mboxgrep/mboxgrep/0.7.9/mboxgrep-0.7.9.tar.gz"
  sha1 "dc6dcaee5fc22bf606328b378883da34600be11a"

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make"
    system "make", "install"
  end

  def test
    system "#{bin}/mboxgrep", "--version"
  end
end
