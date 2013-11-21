require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.43.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.43.3.tar.gz'
  sha256 '67978d118980ebd9f0c60be5db129527900a7b997b9568fc795ba9bdb341d303'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
