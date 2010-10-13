require 'formula'

class Vala <Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.10/vala-0.10.0.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 '1e38cdc951d2b43e49084a6d5ad19e9d'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make" # Single step fails to compile for 0.8.0
    system "make install"
  end
end
