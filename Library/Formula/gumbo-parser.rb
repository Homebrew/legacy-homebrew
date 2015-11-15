class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://github.com/google/gumbo-parser"
  url "https://github.com/google/gumbo-parser/archive/v0.10.1.tar.gz"
  sha256 "28463053d44a5dfbc4b77bcf49c8cee119338ffa636cc17fc3378421d714efad"

  bottle do
    cellar :any
    sha256 "892139aee69838ab17bd6b117a2eb3af8b121015bf522f5b167ff3d7a112dd5f" => :yosemite
    sha256 "61ba0bf840ec3cd221925c572c56605861eb31bca7c843bfd8df08e278f43c91" => :mavericks
    sha256 "3eb7dd014c9e3fd8d7bf1b49d513e42f1f7d1bd76af2c5e38d20a0c29d231c05" => :mountain_lion
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
