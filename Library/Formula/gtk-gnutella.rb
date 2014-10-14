require 'formula'

class GtkGnutella < Formula
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  url 'https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.0.0/gtk-gnutella-1.0.0.tar.bz2'
  sha1 'bd38b103dbccbca5d1431330df5c5d5b3eca4a24'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
