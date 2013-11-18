require 'formula'

class Pygobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.8/pygobject-3.8.3.tar.xz'
  sha256 '384b3e1b8d1e7c8796d7eb955380d62946dd0ed9c54ecf0817af2d6b254e082c'

  option 'with-tests', 'run tests'

  depends_on 'pkg-config' => :build

  if build.with? 'tests'
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'libtool' => :build
    depends_on 'gnome-common' => :build
    depends_on 'gtk+3' => :build
  end

  depends_on 'libffi' => :optional
  depends_on 'glib'
  depends_on :python
  depends_on :python3 => :optional
  depends_on 'py2cairo'
  depends_on 'py3cairo' if build.with? 'python3'
  depends_on 'gobject-introspection'

  option :universal

  def patches
    "https://gist.github.com/krrk/6439665/raw/a527e14cd3a77c19b089f27bea884ce46c988f55/pygobject-fix-module.patch" if build.with? 'tests'
  end

  def install
    ENV.universal_binary if build.universal?

    python do
      if build.with? 'tests'
        # autogen.sh is necessary to update the build system after the above
        # patch and XDG_DATA_DIRS needs to be fixed for some tests to run
        inreplace 'tests/Makefile.am', '/usr/share', HOMEBREW_PREFIX/'share'
        system "./autogen.sh"
      end

      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
      system "make", "check" if build.with? 'tests'
    end
  end
end
