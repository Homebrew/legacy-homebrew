require 'formula'

class Stow <Formula
  url 'http://ftp.gnu.org/gnu/stow/stow-1.3.3.tar.gz'
  homepage 'http://www.gnu.org/software/stow/'
  md5 '59a078c7056dd9dd97fb707063b69d03'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}", "--mandir=#{man}"
    system "make install"
  end
end
