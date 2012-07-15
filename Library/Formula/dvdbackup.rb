require 'formula'

class Dvdbackup < Formula
  url 'http://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz'
  homepage 'http://dvdbackup.sourceforge.net'
  md5 'fd9189149ec88520e0ceba8d17520fbb'

  depends_on 'libdvdread'

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
