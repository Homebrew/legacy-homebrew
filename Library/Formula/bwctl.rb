require "formula"

class Bwctl < Formula
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.2-10.tar.gz"
  sha1 "5dcc7a1d671ac8e061f859a430d56ae2551f507e"

  bottle do
    cellar :any
    sha1 "b44fbe6a0a4cb82f9d5f9af6062006bbe22d163c" => :yosemite
    sha1 "318f7c3022df966510467489102ea2f3fa6ea728" => :mavericks
    sha1 "d18b048baeb365d22717b2b831c164eb1c8ba125" => :mountain_lion
  end

  depends_on "i2util"
  depends_on "iperf3" => :optional
  depends_on "thrulay" => :optional

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
