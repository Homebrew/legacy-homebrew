require "formula"

class Libebur128 < Formula
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.0.2.tar.gz"
  sha1 "b1e2949e6598053edb8aeaf71614a26efcb38bd0"

  depends_on "cmake" => :build
  depends_on "speex" => [:recommended, "with-libogg"]

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lebur128", "-o", "test"
    system "./test"
  end
end
