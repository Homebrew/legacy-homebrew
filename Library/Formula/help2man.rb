require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.44.1.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.44.1.tar.xz'
  sha256 '22de6846771921f455e389cdca07119d7f55b1877685b42dd5bbb9fc1377defb'

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
