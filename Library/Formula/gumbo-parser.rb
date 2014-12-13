require "formula"

class GumboParser < Formula
  homepage "https://github.com/google/gumbo-parser"
  url "https://github.com/google/gumbo-parser/archive/v0.9.2.tar.gz"
  sha1 "5462f09266bf8e3470b1917ca9a1d4bab9d3e87d"

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
    (testpath/'test.c').write <<-EOS.undent
    #include <gumbo.h>

    int main() {
        GumboOutput *output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
    }
    EOS
    system ENV.cc, testpath/'test.c', "-L#{lib}", "-lgumbo", "-o", "test"
    system testpath/'test'
  end
end
