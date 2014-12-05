require "formula"

class Bwctl < Formula
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.2-10.tar.gz"
  sha1 "5dcc7a1d671ac8e061f859a430d56ae2551f507e"

  depends_on "i2util"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end
