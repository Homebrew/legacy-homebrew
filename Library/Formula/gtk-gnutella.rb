require 'formula'

class GtkGnutella < Formula
  url 'http://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/0.97.1/gtk-gnutella-0.97.1.tar.bz2'
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  md5 '7ded76ca9892b58b0e9314ee563e4bae'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
