require 'formula'

class Atkmm < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/atkmm/2.22/atkmm-2.22.5.tar.bz2'
  homepage 'http://www.gnome.org/'
  md5 'd56fe2b29d4c88fa270918e5572fc8cf'

  depends_on 'atk'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "pkg-config atkmm-1.6"
  end
end
