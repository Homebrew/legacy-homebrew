class Bgpdump < Formula
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  desc "A  C library designed to help with analyzing dump files produced by Zebra/Quagga or MRT"
  url "https://bitbucket.org/ripencc/bgpdump/get/1.4.99.15.tar.gz"
  sha256 "6da4ef4020345c68a2551460919ec02b7b63c194324e209fc73bea9889fb5c7c"
  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
