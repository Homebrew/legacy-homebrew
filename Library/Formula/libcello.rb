class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  url "http://libcello.org/static/libCello-2.0.3.tar.gz"
  sha256 "2ebe995f0175c8397f41a32751e60d1b4907eddae7c1442c67d484a16d1c6b99"
  head "https://github.com/orangeduck/libCello.git"

  bottle do
    cellar :any
    revision 1
    sha256 "99e4284df31d64596818917832663c6ddca528d1cf0dee15a29152261dde7dae" => :yosemite
    sha256 "9f018f1773ca94ce29a5d534dde008ddaa9bf66d8ef2c30d0e341e1fe36bf468" => :mavericks
    sha256 "4730b47efc29ea8896151ec04afc6b3426cb76669bc65d37f3aa33a5e935fa46" => :mountain_lion
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
