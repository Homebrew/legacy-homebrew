class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.1.0.tar.gz"
  sha256 "c60e78f4bfda387a0895c64a4fc9850445e3a4425cc98f9140885966ce17c1d1"

  bottle do
    cellar :any
    sha256 "d9c7285c092cf1b75420963efd4f8540fab99ead1e49c7656cab4491c782ec70" => :el_capitan
    sha256 "09e07df1dd7a1ec59cf2e7eada5208a144d2e8d561dc0da6ce0baefe64006312" => :yosemite
    sha256 "4070ef3a044c9c9df6adf95bccc9a33faeac8a4d7b29b326135139b404df2b95" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
