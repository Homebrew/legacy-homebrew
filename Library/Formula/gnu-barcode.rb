require "formula"

class GnuBarcode < Formula
  homepage "https://www.gnu.org/software/barcode/"
  url "http://ftpmirror.gnu.org/barcode/barcode-0.99.tar.xz"
  mirror "https://ftp.gnu.org/gnu/barcode/barcode-0.99.tar.xz"
  sha1 "a6283a844ebfdccc9458256e5e6db15760348384"

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
end
