require 'formula'

class JsonGlib < Formula
  homepage 'http://live.gnome.org/JsonGlib'
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/json-glib/0.12/json-glib-0.12.4.tar.bz2'
  sha256 '462cd611016ae189d5e3f258dc7741e6a2e8267404b4e3806aaf346d50f1df7e'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
