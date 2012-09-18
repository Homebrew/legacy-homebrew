require 'formula'

class Jcal < Formula
  homepage 'http://savannah.nongnu.org/projects/jcal/'
  url 'http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz'
  sha1 '23710a685515e1e824494890d6befac9edf04143'

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
