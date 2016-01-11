class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  head "https://github.com/jessek/hashdeep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "986dad46d2945aac775eb625e41b0236f2413b3924244d5e9aba445994c38687" => :el_capitan
    sha256 "227b8b8e4f4dd71972cd02062faefef90515b44ef5c3ce55f5c665cf679a26d1" => :yosemite
    sha256 "1bacd45d420975ff8b90d633e361b54c7f6a14776a41f175313360d31fb03ba4" => :mavericks
    sha256 "5d68af238b95cffd8959418d804212c50a69cbae90c203d4abb56ceafea93399" => :mountain_lion
  end

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
