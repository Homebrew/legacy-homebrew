require 'formula'

class Libgsasl < Formula
  url 'http://ftpmirror.gnu.org/gsasl/libgsasl-1.6.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsasl/libgsasl-1.6.1.tar.gz'
  homepage 'http://www.gnu.org/software/gsasl/'
  md5 '143ab88d06a5217915e6b649d7ffc018'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
