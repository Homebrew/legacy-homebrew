require 'formula'

class Libgpod < Formula
  url 'http://downloads.sourceforge.net/project/gtkpod/libgpod/libgpod-0.8/libgpod-0.8.2.tar.bz2'
  homepage 'http://www.gtkpod.org/wiki/Libgpod'
  md5 'ff0fd875fa08f2a6a49dec57ce3367ab'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gdk-pixbuf'
  depends_on 'sqlite'

  def patches
    # fixes sys/mount.h calls
    "https://raw.github.com/gist/d030f697aaca3f917b4a/93476cd60ef1e411695211f31a2f486b021dbb9a/gistfile1.diff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make all"
    system "make -C src install"
    bin.install [
      'tools/.libs',
      'tools/ipod-read-sysinfo-extended',
      'tools/ipod-set-info',
      'tools/iphone-set-info'
      ]
  end
end
