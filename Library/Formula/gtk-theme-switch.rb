require 'formula'

class GtkThemeSwitch < Formula
  homepage 'http://freecode.com/projects/gtkthemeswitch'
  url 'http://ftp.debian.org/debian/pool/main/g/gtk-theme-switch/gtk-theme-switch_2.1.0.orig.tar.gz'
  md5 'a9e7e62701cd4fba4d277dc210cd4317'

  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'

  def install
    system "make install" 
  end
end
