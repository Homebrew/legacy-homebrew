require 'formula'

class Zile <Formula
  url 'http://ftp.gnu.org/gnu/zile/zile-2.3.16.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 'df52bc24ee5126dbbf76fa5a8eda87b9'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
