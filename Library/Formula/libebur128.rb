class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.0.2.tar.gz"
  sha256 "9b334d31a26b47ba6740bb7bbee7a24461d535f426b1ed42368c187e27c08323"

  bottle do
    cellar :any
    revision 2
    sha1 "69b35529f8165ed8cac324b10d52ce3671e7ab66" => :yosemite
    sha1 "5d44054e39a6f9c9ad27754ea94bd785e913847e" => :mavericks
    sha1 "f064843d5ebf08a42d5e02809e398907a242e37d" => :mountain_lion
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
