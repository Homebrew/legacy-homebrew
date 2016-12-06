require 'formula'

class DbusPython < Formula
  homepage 'http://dbus.freedesktop.org/doc/dbus-python/README.html'
  url 'http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.0.tar.gz'
  sha1 '7a00f7861d26683ab7e3f4418860bd426deed9b5'
  
  depends_on 'pkg-config' => :build
  depends_on "dbus-glib"
  
  def patches
    p = []
    p << 'https://gist.github.com/hanxue/7048247/raw/698d65b94543872a0301793aa2c02c25e732fa44/dbus-python.patch'
    # Patch to create setup.py for dbus-python
    # Based on this bug https://bugs.freedesktop.org/show_bug.cgi?id=55439
    # Original patch file at https://bugs.freedesktop.org/attachment.cgi?id=80061
    p
  end
  
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
