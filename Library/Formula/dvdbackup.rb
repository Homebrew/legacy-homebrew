require 'formula'

class Dvdbackup <Formula
  url 'http://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.1.tar.bz2'
  homepage 'http://dvdbackup.sourceforge.net'
  md5 'e4b35ba716852361f35cecafff44f37c'

  depends_on 'libdvdread'

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
