require 'formula'

class Jcal < Formula
  homepage 'http://savannah.nongnu.org/projects/jcal/'
  url 'http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz'
  md5 'd4f94ee612494cd0ab0cf1f537aaa33b'

  if MacOS.xcode_version >= "4.3"
    # when and if the tarball provides configure, remove autogen.sh and these deps
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
