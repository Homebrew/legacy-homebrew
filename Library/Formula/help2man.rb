require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.6.tar.gz'
  sha1 '4a34dd9e74e1c17e2654269b41f1010ea1d9a387'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
