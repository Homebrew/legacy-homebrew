require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.11.tar.gz'
  sha256 '34ad76638facd75d5bbc771a6827d1cbc43c435ae64321fb5a9d7b339a861835'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
