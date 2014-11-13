require 'formula'

class Libksba < Formula
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.1.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.1.tar.bz2'
  sha1 '6bfe285dbc3a7b6e295f9389c20ea1cdf4947ee5'

  bottle do
    cellar :any
    revision 1
    sha1 "4c6d52633b6c610529c22d67ae70853608630f6a" => :yosemite
    sha1 "605336e6018ebfc4b688bc007f05e94259d8643e" => :mavericks
    sha1 "5ded6d36bc756f8dd8d07a838efcd780b510ce96" => :mountain_lion
  end

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
