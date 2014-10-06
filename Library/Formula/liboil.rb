require 'formula'

class Liboil < Formula
  homepage 'http://liboil.freedesktop.org/'
  url 'http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz'
  sha1 'f9d7103a3a4a4089f56197f81871ae9129d229ed'

  bottle do
    cellar :any
    sha1 "176c60456a40a7f288a60d759408a9221d4f30bd" => :mavericks
    sha1 "1119a4fc9dbc042bd9be59f7f6235cbd0581a289" => :mountain_lion
    sha1 "2b858e29b011a1393e79b5643f15cf8680d6e3b1" => :lion
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
