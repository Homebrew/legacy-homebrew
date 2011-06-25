require 'formula'

class Help2man < Formula
  url 'http://ftp.gnu.org/gnu/help2man/help2man-1.37.1.tar.gz'
  homepage 'http://www.gnu.org/software/help2man/'
  md5 '371b5cc74fe9c2ea3ee1ca23c19b19a8'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
