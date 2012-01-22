require 'formula'

class Jcal < Formula
  url 'http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz'
  md5 'd4f94ee612494cd0ab0cf1f537aaa33b'
  homepage 'http://savannah.nongnu.org/projects/jcal/'

  def install
    system "/bin/sh autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/jcal -y"
    system "#{HOMEBREW_PREFIX}/bin/jdate"
  end
end
