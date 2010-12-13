require 'formula'

class Ssdeep <Formula
  url 'http://downloads.sourceforge.net/project/ssdeep/ssdeep-2.5/ssdeep-2.5.tar.gz'
  homepage 'http://ssdeep.sourceforge.net/'
  md5 'f3212dbf27384a00ad5eab1fb81fe3d1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
