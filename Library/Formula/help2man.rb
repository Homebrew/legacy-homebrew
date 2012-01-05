require 'formula'

class Help2man < Formula
  url 'http://ftpmirror.gnu.org/help2man/help2man-1.40.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/help2man/help2man-1.40.5.tar.gz'
  homepage 'http://www.gnu.org/software/help2man/'
  md5 '75a7d2f93765cd367aab98986a75f88c'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Skip making the "info" files.
    system "make help2man man"
    bin.install "help2man"
    man1.install gzip("help2man.1")
  end
end
