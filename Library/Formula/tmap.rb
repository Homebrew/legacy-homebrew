require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.7'
  md5 '25bc520aa791f6994e2a62e3432f8a95'

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
