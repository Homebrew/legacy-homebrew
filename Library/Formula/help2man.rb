require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.7.tar.gz'
  sha1 '6df4a02f54629832a641f00be2c6b61cec0095d2'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
