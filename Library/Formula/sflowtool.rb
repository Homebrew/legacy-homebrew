require 'formula'

class Sflowtool < Formula
  homepage 'http://www.inmon.com/technology/sflowTools.php'
  url 'http://www.inmon.com/bin/sflowtool-3.27.tar.gz'
  sha1 '5205ef2df9cc0b1253765a27ea200446c4525642'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "#{bin}/sflowtool -h 2>&1 | grep version"
  end
end
