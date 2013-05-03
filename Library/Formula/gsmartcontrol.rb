require 'formula'

class Gsmartcontrol < Formula
  homepage 'http://gsmartcontrol.berlios.de/'
  url 'http://download.berlios.de/gsmartcontrol/gsmartcontrol-0.8.7.tar.bz2'
  sha1 '36c255e8f493b003a616cb1eff3a86ccc6b8f80a'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'smartmontools'
  depends_on 'gtkmm'
  depends_on 'pcre'
  depends_on 'libglademm'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/gsmartcontrol", "--version"
  end
end
