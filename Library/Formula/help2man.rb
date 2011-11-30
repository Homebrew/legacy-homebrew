require 'formula'

class Help2man < Formula
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.4.tar.gz'
  homepage 'http://www.gnu.org/software/help2man/'
  md5 '4d79dc7cb7c20019c2a3650d35259c45'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
