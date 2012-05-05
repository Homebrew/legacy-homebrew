require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.7'
  md5 '2283f15ca05c27c534cef22850711bba'
  version '0.3.7'

  head 'https://github.com/iontorrent/TMAP.git'

  fails_with :clang do
    build 318
  end

  def install
    system "sh autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/tmap -v"
  end
end
