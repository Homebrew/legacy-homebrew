require "formula"

class Bwctl < Formula
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any
    sha1 "b44fbe6a0a4cb82f9d5f9af6062006bbe22d163c" => :yosemite
    sha1 "318f7c3022df966510467489102ea2f3fa6ea728" => :mavericks
    sha1 "d18b048baeb365d22717b2b831c164eb1c8ba125" => :mountain_lion
  end

  depends_on "i2util" => :build
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
