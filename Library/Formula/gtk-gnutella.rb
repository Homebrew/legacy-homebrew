require 'formula'

class GtkGnutella < Formula
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  url 'https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.0.1/gtk-gnutella-1.0.1.tar.bz2'
  sha1 'd01b7ac03550200a858efd076bff4fa625962111'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
