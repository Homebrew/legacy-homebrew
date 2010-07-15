require 'formula'

class Gphoto2 <Formula
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.9/gphoto2-2.4.9.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 'a08a93a425cde03ca8f9bade83bbd26a'

  depends_on 'pkg-config'
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'

  def install
    system "./configure", "--without-readline", "--without-cdk", "--without-aalib", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
