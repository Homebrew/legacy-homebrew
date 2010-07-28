require 'formula'

class Aldo <Formula
  url 'http://savannah.nongnu.org/download/aldo/aldo-0.7.6.tar.bz2'
  homepage 'http://www.nongnu.org/aldo/'
  md5 'c870b62fe50f71eb6c7ddcd5d666d2e2'

  depends_on 'libao'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
