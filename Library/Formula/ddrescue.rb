require "formula"

class Ddrescue < Formula
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "http://ftpmirror.gnu.org/ddrescue/ddrescue-1.19.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.19.tar.lz"
  sha1 "5c5bfa4e2d0cb98feb1fd66cb9ea0c8ab2c7d34d"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end
end
