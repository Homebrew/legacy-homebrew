require 'formula'

class Vala <Formula
  url 'http://download.gnome.org/sources/vala/0.7/vala-0.7.8.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 'accd0d350c6d6de7527a0a65c40f8be2'

  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
