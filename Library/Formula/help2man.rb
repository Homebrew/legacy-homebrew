require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.41.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.41.1.tar.gz'
  sha256 '3a650ada9453700e34355770d4f74f257fb1dda1a0f24f44b8a3c1d4cb1ee40d'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
