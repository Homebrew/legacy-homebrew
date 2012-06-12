require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.10.tar.gz'
  sha256 'f7c85b9af84a87d7da912b62dadf426118841750ed1e4598787a54fddaf82b9c'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
