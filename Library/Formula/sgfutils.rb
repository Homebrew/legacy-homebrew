class Sgfutils < Formula
  desc "collection of command-line utilities to work with SGF files"
  homepage "http://homepages.cwi.nl/~aeb/go/sgfutils/html/sgfutils.html"
  url "http://homepages.cwi.nl/~aeb/go/sgfutils/sgfutils-0.22.tgz"
  sha256 "4ad83be91ac3a52dd8bd0766bfe403499430da96e680c5aea2f5381ba0b34923"

  bottle do
    cellar :any
    sha256 "4bf26ce188f979f02ca05b77bf1d043e65109aa57097eb1d50e4d7a56e5080f2" => :el_capitan
    sha256 "13c3312694adee8c1b34a5b1ea3b1b391637958db3e28dcd257a6c32f3904516" => :yosemite
    sha256 "bd3341fad2702bf1e92f10b34d7c64be16dbeb74a404d0dc348560fd46e6853c" => :mavericks
  end

  depends_on "openssl"

  def install
    bin_files = %w[
      ngf2sgf nip2sgf nk2sgf sgf sgfcharset sgfcheck sgfcmp sgfdb sgfdbinfo
      sgfinfo sgfmerge sgfsplit sgfstrip sgftf sgftopng sgfvarsplit sgfx ugi2sgf
    ]
    system "make", "all", "LDLIBS=-liconv"
    bin_files.each { |file| bin.install file }
  end

  test do
    (testpath/"temp.sgf").write "(;SZ[2];B[aa];W[ab];B[bb])"
    actual = shell_output("#{bin}/sgftf -rot90 temp.sgf")
    expected = <<-EOS.undent
      (;
      SZ[2]

      ;B[ab];W[bb];B[ba])
    EOS
    assert_equal expected, actual
  end
end
