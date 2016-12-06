require 'formula'

class GtkThemeSwitch < Formula
  homepage 'http://freecode.com/projects/gtkthemeswitch'
  url 'http://ftp.debian.org/debian/pool/main/g/gtk-theme-switch/gtk-theme-switch_2.1.0.orig.tar.gz'
  sha1 'f42cd43df5ed671e9eb9c180de944f77e1bdc879'

  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'
  depends_on 'intltool'
  depends_on 'pkg-config'

  def install
    system 'make', "PREFIX=#{prefix}", 'install'
  end

  def test
    system 'gtk-theme-switch2'
  end
end
