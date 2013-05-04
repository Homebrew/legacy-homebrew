require 'formula'

class Gpsim < Formula
  homepage 'http://gpsim.sourceforge.net/'
  url 'http://sourceforge.net/projects/gpsim/files/gpsim/0.25.0/gpsim-0.25.0.tar.gz'
  sha1 'bff4122ad29adbd64c6ee37159698dfd0d6ca503'

  depends_on 'pkg-config' => :build
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
