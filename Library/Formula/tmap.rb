require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.7'
  md5 '2283f15ca05c27c534cef22850711bba'

  head 'git://github.com/iontorrent/TMAP.git', :using => :git

  def install
    system "sh autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "tmap"
  end
end
