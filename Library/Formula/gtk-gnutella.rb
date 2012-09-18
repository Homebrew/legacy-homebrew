require 'formula'

class GtkGnutella < Formula
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  url 'http://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/0.97.1/gtk-gnutella-0.97.1.tar.bz2'
  sha1 '14a4b5fd8c35cbed443e9997e55e44aafba05906'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
