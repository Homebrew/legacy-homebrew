require 'formula'

class Gpsim <Formula
  url 'http://sourceforge.net/projects/gpsim/files/gpsim/0.25.0/gpsim-0.25.0.tar.gz'
  homepage 'http://gpsim.sourceforge.net/'
  md5 '36e2aeac30fad773f5fb934c867b42b7'

  depends_on 'pkg-config'
  depends_on 'popt'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end