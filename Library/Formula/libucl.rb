class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.0.tar.gz"
  sha256 "af361cd1f0b7b66c228a1c04a662ccaa9ee8af79842046c04446d915db349ee1"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
      #include <fstream>
      #include <iostream>
      #include <string>
      #include <ucl++.h>
      #include <cassert>

      int main(int argc, char **argv) {
        assert(argc == 2);
        std::ifstream file(argv[1]);
        std::string err;
        auto obj = ucl::Ucl::parse(file, err);
        if (!obj) {
          return 1;
        }
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    EOS
    (testpath/"test.cfg").write <<-EOS.undent
      foo = bar;
      section {
        flag = true;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-lucl", "-o", "test"
    system "./test", testpath/"test.cfg"
  end
end
