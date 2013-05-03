require 'formula'

class GtkGnutella < Formula
  homepage 'http://gtk-gnutella.sourceforge.net/en/?page=news'
  url 'http://sourceforge.net/projects/gtk-gnutella/files/gtk-gnutella/0.98.4/gtk-gnutella-0.98.4.tar.bz2'
  sha1 'fdef274c85f3735642b9dc982a52a477b9223f06'

  depends_on 'gtk+'

  def install
    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end
end
