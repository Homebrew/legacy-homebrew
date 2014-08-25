require "formula"

class Zbackup < Formula
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.2.tar.gz"
  sha1 "e87dfaeeeea0d59f4af00d3ce248aaabf1a25cb9"
  revision 1

  bottle do
    cellar :any
    sha1 "346eb5faf369ed6843c8babca0d6f1dcce7795f9" => :mavericks
    sha1 "4e2f6e6258feaf7723c40c9c6b66348e0a03bab3" => :mountain_lion
    sha1 "d9641dcca384fda680615ed3add69ff13e8799a5" => :lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup backup backups/test.bak"
  end
end
