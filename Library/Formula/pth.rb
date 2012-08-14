require 'formula'

class Pth < Formula
  url 'http://ftpmirror.gnu.org/pth/pth-2.0.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz'
  homepage 'http://www.gnu.org/software/pth/'
  md5 '9cb4a25331a4c4db866a31cbe507c793'

  def install
    ENV.deparallelize
    # Note: shared library will not be build with --disable-debug, so don't add that flag
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
