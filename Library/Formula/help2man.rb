require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.13.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.13.tar.gz'
  sha256 '15d3b6ebbac90f6d2a21480ba5e33c03b480a342ce498a84b1804f03d75358ba'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
