require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.13/libgphoto2-2.4.13.tar.bz2'
  md5 'd20a32fe2bb7d802a6a8c3b6f7f97c5e'
  
  head "https://gphoto.svn.sourceforge.net/svnroot/gphoto/branches/libgphoto2-2_4/libgphoto2"
  depends_on 'gettext' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    if ARGV.include? '--HEAD'
      system "autoreconf --install"
    end
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
