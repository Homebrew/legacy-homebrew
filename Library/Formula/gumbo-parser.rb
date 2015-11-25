class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://github.com/google/gumbo-parser"
  url "https://github.com/google/gumbo-parser/archive/v0.10.1.tar.gz"
  sha256 "28463053d44a5dfbc4b77bcf49c8cee119338ffa636cc17fc3378421d714efad"

  bottle do
    cellar :any
    sha256 "56f5446eb431b628655748659a8a7479466e00addf7d90070464364a3f3cafa9" => :el_capitan
    sha256 "02169cdaafcf9343bacf98e0e34b1f7383eb0b1b89385965d81796e110f8c38f" => :yosemite
    sha256 "efc9658f05e6543d7faed663ef7106c5720e72a86672d7ef000372babade1e43" => :mavericks
  end

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
