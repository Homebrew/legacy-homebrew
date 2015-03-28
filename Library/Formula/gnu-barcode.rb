class GnuBarcode < Formula
  homepage "http://www.gnu.org/software/barcode/"
  url "http://ftpmirror.gnu.org/barcode/barcode-0.99.tar.gz"
  mirror "http://ftp.gnu.org/gnu/barcode/barcode-0.99.tar.gz"
  sha1 "6909341696e83b5cf398251d6f466aa3fa91dda9"

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
