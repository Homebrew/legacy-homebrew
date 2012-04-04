require 'formula'

class GtkEngines < Formula
  homepage 'http://git.gnome.org/browse/gtk-engines/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2'
  md5 '5deb287bc6075dc21812130604c7dc4f'

  depends_on 'pkg-config' => :build
  depends_on 'gettext' => :build
  depends_on 'cairo' # we need exactly the same cairo as gtk has been linked against
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "/bin/sh", "-c", "GTK2_RC_FILES=#{share}/themes/Clearlooks/gtk-2.0/gtkrc " \
      "GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0 " "#{HOMEBREW_PREFIX}/bin/gtk-demo"
  end

  def caveats
    "You will probably need to set GTK_PATH environment variable to #{HOMEBREW_PREFIX}/lib/gtk-2.0\n" \
    "as by default GTK looks for modules in Cellar."
  end
end
