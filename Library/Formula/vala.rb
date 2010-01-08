require 'formula'

class Vala <Formula
  url 'http://download.gnome.org/sources/vala/0.7/vala-0.7.9.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 'f2f8b2914361db599fd6392ec27f7042'

  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
