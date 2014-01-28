require 'formula'

class Byacc < Formula
  homepage 'http://invisible-island.net/byacc/byacc.html'
  url 'ftp://invisible-island.net/byacc/byacc-20130925.tgz'
  sha1 '6f49b2c730a5ad9882f823f40dc617713f42fc73'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make install"
  end
end
