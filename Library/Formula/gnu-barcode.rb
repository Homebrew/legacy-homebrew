class GnuBarcode < Formula
  desc "Convert text strings to printed bars"
  homepage "https://www.gnu.org/software/barcode/"
  url "http://ftpmirror.gnu.org/barcode/barcode-0.98.tar.gz"
  mirror "https://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz"
  sha256 "4229e19279b9787ac7e98852fa0bfd93986dce93b9cb07d93a017d68d409b635"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "MAN1DIR=#{man1}",
                   "MAN3DIR=#{man3}",
                   "INFODIR=#{info}",
                   "install"
  end

  test do
    (testpath/"test.txt").write("12345")
    system "#{bin}/barcode", "-e", "CODE39", "-i", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
