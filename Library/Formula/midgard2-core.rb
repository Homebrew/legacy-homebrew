require 'formula'

class Midgard2Core <Formula
  url 'http://www.midgard-project.org/midcom-serveattachmentguid-15523dd2335f11e0a6211573cef6d313d313/midgard2-core-10.05.3.tar.gz'
  homepage 'http://www.midgard-project.org/'
  md5 '369641da2e989db01592f2a93ccdd065'

  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'
  depends_on 'pkg-config'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-libgda4", "--with-dbus-support", "--enable-introspection=no"
    system "make install"
  end
end
