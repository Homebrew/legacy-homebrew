require 'brewkit'

class Vala <Formula
  @url='http://download.gnome.org/sources/vala/0.7/vala-0.7.5.tar.bz2'
  @homepage='http://live.gnome.org/Vala'
  @md5='a102d582b2ac75b6bcdc5785683263fc'

  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
