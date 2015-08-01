class Bgpdump < Formula
  desc "A  C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  url "https://bitbucket.org/ripencc/bgpdump/get/1.4.99.15.tar.gz"
  sha256 "6da4ef4020345c68a2551460919ec02b7b63c194324e209fc73bea9889fb5c7c"

  bottle do
    cellar :any
    sha256 "b891499f28cf91dcc347eaca860d2cb69945c52a65827b634da27cf79b933b0e" => :yosemite
    sha256 "875e8aa73ba145cc891f2550b6d4140effa50619f3846118c38a0e9e6711472d" => :mavericks
    sha256 "762297d9b9ed36a37789e75d81ab6702fb63c3761b7c3ba00da999425be2f179" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
