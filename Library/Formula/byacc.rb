require 'formula'

class Byacc < Formula
  homepage 'http://invisible-island.net/byacc/byacc.html'
  url 'ftp://invisible-island.net/byacc/byacc-20120526.tgz'
  sha1 '69662091c2ad42e4048860b886adbf5bab5a53a6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make install"
  end
end
