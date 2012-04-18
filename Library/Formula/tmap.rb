require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.7'
  md5 '032741c677c5aca211984b0e79130169'

  head 'https://github.com/iontorrent/TMAP.git'

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
