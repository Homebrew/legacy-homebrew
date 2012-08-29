require 'formula'

class Sflowtool < Formula
  homepage 'http://www.inmon.com/technology/sflowTools.php'
  url 'http://www.inmon.com/bin/sflowtool-3.25.tar.gz'
  md5 'e7b4b487f057f0f1daeac7cf67dc7d86'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "sflowtool -h 2>&1 | grep version"
  end
end
