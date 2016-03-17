class Sgfutils < Formula
  desc "collection of command-line utilities to work with SGF files"
  homepage "http://homepages.cwi.nl/~aeb/go/sgfutils/html/sgfutils.html"
  url "http://homepages.cwi.nl/~aeb/go/sgfutils/sgfutils-0.22.tgz"
  sha256 "4ad83be91ac3a52dd8bd0766bfe403499430da96e680c5aea2f5381ba0b34923"

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
