require 'formula'

class Zile <Formula
  url 'http://ftp.gnu.org/gnu/zile/zile-2.3.17.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 'd4a4409fd457e0cb51c76dd8dc09d18b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
