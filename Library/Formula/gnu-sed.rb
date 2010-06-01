require 'formula'

class GnuSed <Formula
  url 'http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.bz2'
  homepage 'http://www.gnu.org/software/sed/'
  md5 '7d310fbd76e01a01115075c1fd3f455a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--program-prefix=g"
    system "make install"
  end
end
