require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.43.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.43.2.tar.gz'
  sha256 'ec43eb74669e02cb61af142f1398bb882ff1dbbc9a8cc4f8cd70098fe425e4a9'

  def install
    # install is not parallel safe
    # see https://github.com/mxcl/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
