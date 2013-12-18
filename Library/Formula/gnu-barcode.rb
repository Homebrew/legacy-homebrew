require 'formula'

class GnuBarcode < Formula
  homepage 'http://www.gnu.org/software/barcode/'
  url 'http://ftpmirror.gnu.org/barcode/barcode-0.98.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz'
  sha1 '15b9598bcaa67bcff1f63309d1a18840b9a12899'

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
