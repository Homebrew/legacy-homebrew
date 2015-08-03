class Liboil < Formula
  desc "C library of simple functions optimized for various CPUs"
  homepage "http://liboil.freedesktop.org/"
  url "http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz"
  sha256 "105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69"

  bottle do
    cellar :any
    revision 1
    sha1 "1d7f799090d7ccfe52341971822d3af1269ea68f" => :yosemite
    sha1 "14d746548dc6e18f900e4fe67d1f1958fda68016" => :mavericks
    sha1 "41590a673b637d2307b1ce287ec692e4d47b3191" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "CFLAGS", "-fheinous-gnu-extensions" if ENV.compiler == :clang
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <liboil/liboil.h>
      int main(int argc, char** argv) {
        oil_init();
        return 0;
      }
    EOS

    flags = ["-I#{include}/liboil-0.3", "-L#{lib}", "-loil-0.3"] + ENV.cflags.to_s.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
