require 'formula'

class IsoCodes < Formula
  url 'http://ftp.us.debian.org/debian/pool/main/i/iso-codes/iso-codes_3.28.orig.tar.bz2'
  homepage 'http://pkg-isocodes.alioth.debian.org/'
  md5 'f84dda8dcf7ffdcbe64c82b7c2165bf8'

  depends_on 'gettext' => :build

  def install
    # Add keg-only gettext bin to path
    ENV.append 'PATH', Formula.factory('gettext').bin

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
