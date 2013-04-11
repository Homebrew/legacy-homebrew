require 'formula'

class Pth < Formula
  homepage 'http://www.gnu.org/software/pth/'
  url 'http://ftpmirror.gnu.org/pth/pth-2.0.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz'
  sha1 '9a71915c89ff2414de69fe104ae1016d513afeee'

  def install
    ENV.deparallelize
    # Note: shared library will not be build with --disable-debug, so don't add that flag
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
