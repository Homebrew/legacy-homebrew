class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin/secp256k1"
  url "https://github.com/bitcoin/secp256k1.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
