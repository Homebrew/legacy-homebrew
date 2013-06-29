require 'formula'

class Gphoto2 < Formula
  homepage 'http://gphoto.org/'
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.5.2/gphoto2-2.5.2.tar.bz2'
  sha1 '7f620013772318dbe348fdb0ae4638ab9898cc62'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
