require 'formula'

class JsonGlib < Formula
  homepage 'http://live.gnome.org/JsonGlib'
  url 'http://ftp.gnome.org/pub/GNOME/sources/json-glib/0.15/json-glib-0.15.2.tar.xz'
  sha256 'f090cd94acc85989e033d72028fa70863d05092ae5bba6b454e70c132b24cdde'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
