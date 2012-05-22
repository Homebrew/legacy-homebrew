require 'formula'

class Gphoto2 < Formula
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.11/gphoto2-2.4.11.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 '2635075f702b40eb2e95a80658bd4773'
  head 'https://gphoto.svn.sourceforge.net/svnroot/gphoto/branches/libgphoto2-2_4/gphoto2'
   
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'
  depends_on 'readline'

  def install
    if ARGV.include? '--HEAD'
      system "autoreconf --install"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-aalib"
    system "make install"
  end
end
