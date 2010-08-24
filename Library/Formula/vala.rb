require 'formula'

class Vala <Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.9/vala-0.9.7.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 '3062fe00c0f5b8f40cd2a94ff9bbe2da'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make" # Single step fails to compile for 0.8.0
    system "make install"
  end
end
