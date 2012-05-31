require 'formula'

class JsonGlib < Formula
  homepage 'http://live.gnome.org/JsonGlib'
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/json-glib/0.14/json-glib-0.14.2.tar.bz2'
  sha256 'b62cb148ae49d30d8ad807912ba3c7cf189459e2d75233620aae411cf8ea6c04'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
