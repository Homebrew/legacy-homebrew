require 'formula'

class Help2man < Formula
  homepage 'http://www.gnu.org/software/help2man/'
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.9.tar.gz'
  sha1 '3957023ee890ec391b539236f3f7c5b89b240e3f'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
