require "formula"

class Zbackup < Formula
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.2.tar.gz"
  sha1 "e87dfaeeeea0d59f4af00d3ce248aaabf1a25cb9"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "1d28b24746ec35d2feb35f0adb22cf6e5806137d" => :mavericks
    sha1 "635950c6c99291fe18c6f262463c11b526633600" => :mountain_lion
    sha1 "e25f1167ff8201c438bf5aad13ab2cdd93ce9f99" => :lion
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
