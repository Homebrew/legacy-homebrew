require 'formula'

class Libdvdread < Formula
  homepage 'http://www.dtek.chalmers.se/groups/dvd/'
  # Official site is down; use a mirror.
  url 'http://www.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdread-4.1.3.tar.bz2'
  md5 '6dc068d442c85a3cdd5ad3da75f6c6e8'

  depends_on 'libdvdcss' => :optional

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
