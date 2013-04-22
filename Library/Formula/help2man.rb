require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.41.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.41.2.tar.gz'
  sha256 '6a8c94cde314fdfd1e9e397eeebf2c57b0603c8cc2a2ec9228c7778e1a0940ab'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
