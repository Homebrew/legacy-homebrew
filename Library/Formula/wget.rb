require 'brewkit'

class Wget <Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftp.gnu.org/gnu/wget/wget-1.11.4.tar.bz2'
  md5 'f5076a8c2ec2b7f334cb6e3059820f9c'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
