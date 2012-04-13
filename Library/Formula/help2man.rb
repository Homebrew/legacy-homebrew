require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.8.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.8.tar.gz'
  sha1 '8a3ecc379586d60e541e224e98920746130b531b'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
