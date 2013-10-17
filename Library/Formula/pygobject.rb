require 'formula'

class Pygobject < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.8/pygobject-3.8.3.tar.xz'
  sha256 '384b3e1b8d1e7c8796d7eb955380d62946dd0ed9c54ecf0817af2d6b254e082c'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on :python

  option :universal

  def install
    ENV.universal_binary if build.universal?
    ENV['PKG_CONFIG_PATH'] = "#{HOMEBREW_PREFIX}/lib/pkgconfig/"
    python do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--disable-cairo"
      system "make install"
    end
  end
end
