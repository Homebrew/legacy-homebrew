require 'formula'

class Jcal < Formula
  homepage 'http://savannah.nongnu.org/projects/jcal/'
  url 'http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz'
  md5 'd4f94ee612494cd0ab0cf1f537aaa33b'

  depends_on :automake
  depends_on :libtool

  def install
    system "/bin/sh autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/jcal", "-y"
    system "#{bin}/jdate"
  end
end
