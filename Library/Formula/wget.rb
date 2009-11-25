require 'formula'

class Wget <Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftp.gnu.org/gnu/wget/wget-1.12.tar.bz2'
  md5 '308a5476fc096a8a525d07279a6f6aa3'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
