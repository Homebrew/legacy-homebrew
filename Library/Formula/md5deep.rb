require "formula"

class Md5deep < Formula
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha1 "cb4e313352974299c32bc55fe56396adb74517ef"
  head "https://github.com/jessek/hashdeep.git"

  # This won't work on < Leopard due to using the CommonCrypto Library
  # Not completely impossible to fix, but doubt the demand is there.
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "sh", "bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Do not reduce the spacing of the below text.
    assert_equal "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt",
    shell_output("#{bin}/sha1deep -b testfile.txt").strip
  end
end
