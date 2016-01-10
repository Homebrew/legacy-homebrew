class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.0.2.tar.gz"
  sha256 "9b334d31a26b47ba6740bb7bbee7a24461d535f426b1ed42368c187e27c08323"

  bottle do
    cellar :any
    revision 2
    sha256 "89c5d01361231cbdfba35a811713156b45b96ac15700fb3739303ef421532db4" => :yosemite
    sha256 "e782bbd2456ee327741cfaaa581ff20056ab883c52b9fbd552d4ba0d0b7a8bd5" => :mavericks
    sha256 "7b6c9483078ed5b9add1a550ffcaa4740dba38059b57b06cda66b008f9989ff3" => :mountain_lion
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
