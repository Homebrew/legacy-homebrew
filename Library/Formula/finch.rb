require 'formula'

# Finch is a command-line-only IM client from Pidgin
class Finch < Formula
  url 'http://voxel.dl.sourceforge.net/project/pidgin/Pidgin/2.10.0/pidgin-2.10.0.tar.bz2'
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  md5 'e1453c9093c4f32beec19abd14069a3f'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'libiconv'
  depends_on 'libidn'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'dbus'
  depends_on 'dbus-glib'
  depends_on 'gnutls'
  depends_on 'nss' # Extra for some SSL stuff, probably unrequired

  def install
    # To get it to compile, had to configure without support for:
    #   * Sametime (meanwhile)
    #   * Bonjour (avahi)
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtkui",
                          "--disable-gstreamer",
                          "--disable-vv",
                          "--disable-meanwhile",
                          "--disable-avahi",
                          "--disable-nm",
                          "-with-dbus-services=/usr/local/share/dbus-1/"
    system "make install"
  end
  
  def test
    system "finch --version" # Just to make sure something runs without actually using finch
  end
end
