class GumboParser < Formula
  homepage "https://github.com/google/gumbo-parser"
  url "https://github.com/google/gumbo-parser/archive/v0.9.3.tar.gz"
  sha256 "038354c0394591b270eafc9203aef4516afbf78a66fcb2c4fff5180593b003f0"

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

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include "gumbo.h"

    int main() {
      GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
      gumbo_destroy_output(&kGumboDefaultOptions, output);
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end
