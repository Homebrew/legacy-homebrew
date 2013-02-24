require 'formula'

class Atkmm < Formula
  homepage 'http://www.gtkmm.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/atkmm/2.22/atkmm-2.22.6.tar.bz2'
  sha256 '923d0d638aba70c7f5feff1fc296e0546978afbb049f404b77d97d90dde4e88f'

  depends_on 'pkg-config' => :build
  depends_on 'atk'
  depends_on 'glibmm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
