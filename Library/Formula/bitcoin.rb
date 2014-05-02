require "formula"

class Bitcoin < Formula
  homepage "http://bitcoin.org"
  url "https://github.com/bitcoin/bitcoin/archive/v0.9.1.tar.gz"
  sha1 "f0a591d5ad0b7c5794edd48a64ae7394e108d16a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
