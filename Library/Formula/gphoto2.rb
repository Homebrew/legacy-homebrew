require 'formula'

class Gphoto2 <Formula
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.8/gphoto2-2.4.8.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 '401e403ea6e8301d6c87cbe7cd892b8b'

  depends_on 'pkg-config'
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'

  def install
    system "./configure", "--without-readline", "--without-cdk", "--without-aalib", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
