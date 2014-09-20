require "formula"

class Zbackup < Formula
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.2.tar.gz"
  sha1 "e87dfaeeeea0d59f4af00d3ce248aaabf1a25cb9"
  revision 2

  bottle do
    cellar :any
    sha1 "bdd6068cb3bd4be5fd4d6054b00eb71dd3df04d2" => :mavericks
    sha1 "05dd7547ce1c1cf01113570f091398bb4a120b1e" => :mountain_lion
    sha1 "e021c9af2cfeb75a7bd45e6fd6fd2f8a703b9b68" => :lion
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
