class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  head "https://github.com/jessek/hashdeep.git"

  bottle do
    cellar :any
    sha1 "6c52a36cf6b416a099e3820fc484127ec810e798" => :yosemite
    sha1 "0ce2ae757313c78b6c2f2fc572a8f068bfedd13a" => :mavericks
    sha1 "6e40dd2d2902ef7b01c855089cf5b28098288bdf" => :mountain_lion
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
