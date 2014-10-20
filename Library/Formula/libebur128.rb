require "formula"

class Libebur128 < Formula
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.0.2.tar.gz"
  sha1 "b1e2949e6598053edb8aeaf71614a26efcb38bd0"

  bottle do
    cellar :any
    revision 1
    sha1 "dfccebb326aa92549840710e123e5649c005021c" => :yosemite
    sha1 "fdc4d9fd7175459e02512f979b09a83f578356fc" => :mavericks
    sha1 "35f0ea53a85aba311ecba1186c00f2d57c2f99c9" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "speex" => :recommended

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
