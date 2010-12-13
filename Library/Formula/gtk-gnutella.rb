require 'formula'

class GtkGnutella <Formula
  url 'http://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/0.96.8/gtk-gnutella-0.96.8.tar.bz2'
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  md5 'a9424951fec62cc9f19f2086dc5137b5'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
