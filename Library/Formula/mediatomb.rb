require 'formula'

class Mediatomb <Formula
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.0.tar.gz'
  homepage 'http://mediatomb.cc'
  md5 'd822a3f33ee109f799d7a6b76d394e05'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
