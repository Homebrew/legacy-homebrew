require "formula"

class Lightning < Formula
  homepage "http://www.gnu.org/software/lightning/"
  url "http://ftpmirror.gnu.org/lightning/lightning-2.0.5.tar.gz"
  mirror "http://ftp.gnu.org/gnu/lightning/lightning-2.0.5.tar.gz"
  sha1 "a3b7ba0697690f578bac1d4c991c8e3cbaa33aaf"

  def install
    system "./configure","--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
