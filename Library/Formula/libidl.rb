require 'formula'

class Libidl <Formula
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/libIDL-0.8.13.tar.bz2'
  # The real homepage wasn't responding when this brew was created:
  # homepage 'http://andrewtv.org/libIDL/'
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  md5 'b43b289a859eb38a710f70622c46e571'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
