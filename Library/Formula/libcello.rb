class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  url "http://libcello.org/static/libCello-2.0.3.tar.gz"
  sha256 "2ebe995f0175c8397f41a32751e60d1b4907eddae7c1442c67d484a16d1c6b99"
  head "https://github.com/orangeduck/libCello.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54cfca99a424590796858d57fd1226c763abdf519715b7f7435b812ab504eed6" => :el_capitan
    sha256 "58f80b859bc0d3f40f4de5f1bf39168dd5560a98471c999f76d0416cca5a29fb" => :yosemite
    sha256 "28188bd3d10965c1a9e57d4ca3c652642ddb931a5bf0967fd6141b4dc12e2fc6" => :mavericks
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "Cello.h"

      int main(int argc, char** argv) {
        var i0 = $(Int, 5);
        var i1 = $(Int, 3);
        var items = new(Array, Int, i0, i1);
        foreach (item in items) {
          print("Object %$ is of type %$\\n", item, type_of(item));
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lCello", "-o", "test"
    system "./test"
  end
end
