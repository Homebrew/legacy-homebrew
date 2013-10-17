require 'formula'

class Pygobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.8/pygobject-3.8.3.tar.xz'
  sha256 '384b3e1b8d1e7c8796d7eb955380d62946dd0ed9c54ecf0817af2d6b254e082c'

  option 'with-tests', 'run tests'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  if build.with? 'tests'
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'gnome-common' => :build
    depends_on 'libtool' => :build
    depends_on 'gtk+3' => :build
  end
  depends_on 'glib'
  depends_on :python
  depends_on 'py2cairo'
  depends_on 'gobject-introspection'

  option :universal

  if build.with? 'tests'
    def patches
      # necessary for tests
      "https://gist.github.com/krrk/6439665/download"
    end
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

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      system "make install"
    end

    if build.with? 'tests'
      system "make check"
    end
  end
end
