require 'formula'

class Dvdbackup < Formula
  homepage 'http://dvdbackup.sourceforge.net'
  url 'https://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz'
  sha1 '8265902972c8edcdf66d2030eddc4b752e78c1ca'

  depends_on 'libdvdread'

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
