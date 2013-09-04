require 'formula'

class Pygobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.8/pygobject-3.8.3.tar.xz'
  sha256 '384b3e1b8d1e7c8796d7eb955380d62946dd0ed9c54ecf0817af2d6b254e082c'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on :python
  depends_on 'py2cairo'
  depends_on 'gobject-introspection'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    python do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
    prefix.install Dir['tests']
  end

  test do
    system cd prefix/tests
    system python run_test.py
  end
end
