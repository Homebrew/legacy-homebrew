require "formula"

class Ddrescue < Formula
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "http://ftpmirror.gnu.org/ddrescue/ddrescue-1.18.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.18.1.tar.lz"
  sha1 "97cd3c6c783f3dc5685f0147dc83f3c94fb36b4c"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make install"
  end
end
