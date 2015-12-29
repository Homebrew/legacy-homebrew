class GfComplete < Formula
  desc "Comprehensive Library for Galois Field Arithmetic"
  homepage "http://jerasure.org/"
  url "http://lab.jerasure.org/jerasure/gf-complete/repository/archive.tar.gz?ref=v2.0"
  version "2.0"
  sha256 "0654202fe3b0d3f8a220158699bdea722e47e7f9cbc0fd52e4857aba6a069ea9"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gf_example_3"
  end
end
