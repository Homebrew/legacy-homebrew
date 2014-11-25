require 'formula'

class Libksba < Formula
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.2.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.2.tar.bz2'
  sha1 '37d0893a587354af2b6e49f6ae701ca84f52da67'

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
