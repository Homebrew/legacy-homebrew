require 'formula'

class MoonBuggy < Formula
  homepage 'http://www.seehuhn.de/pages/moon-buggy'
  url 'http://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz'
  md5 '4da97ea40eca686f6f8b164d8b927e38'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  def test
    system "moon-buggy"
  end
end
