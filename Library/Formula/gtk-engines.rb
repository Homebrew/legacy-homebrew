require 'formula'

class GtkEngines < Formula
  homepage 'http://git.gnome.org/browse/gtk-engines/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2'
  sha1 '574c7577d70eaacecd2ffa14e288ef88fdcb6c2a'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'cairo'
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

  def caveats; <<-EOS.undent
    You will need to set:
      GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0
    as by default GTK looks for modules in Cellar.
    EOS
  end
end
