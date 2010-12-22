require 'formula'

class GnuScreen <Formula
  url 'http://ftp.gnu.org/gnu/screen/screen-4.0.3.tar.gz'
  homepage 'http://www.gnu.org/software/screen/'
  md5 '8506fd205028a96c741e4037de6e3c42'

  def install
    system "./configure", "--enable-colors256", "--mandir=#{man}", "--infodir=#{info}", "--prefix=#{prefix}"
                          
    system "make"
    system "make install"
  end

  def patches
    ["https://trac.macports.org/raw-attachment/ticket/20862/screen-4.0.3-snowleopard.patch"]
  end
end
