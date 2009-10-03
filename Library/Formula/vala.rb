require 'brewkit'

class Vala <Formula
  @url='http://download.gnome.org/sources/vala/0.7/vala-0.7.7.tar.bz2'
  @homepage='http://live.gnome.org/Vala'
  @md5='7d11fcddb2bd30b9ecbdacfaa20f2769'

  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
