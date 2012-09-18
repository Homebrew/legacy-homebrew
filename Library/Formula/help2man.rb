require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.12.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.12.tar.gz'
  sha256 'dec8e6e3f570b745a8484d7a4229135f1cf1c5257adf1c590cd094f7d591e4e4'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
