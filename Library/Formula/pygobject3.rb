require "formula"

class Pygobject3 < Formula
  homepage "https://wiki.gnome.org/action/show/Projects/PyGObject"
  url "http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.14/pygobject-3.14.0.tar.xz"
  sha256 "779effa93f4b59cdb72f4ab0128fb3fd82900bf686193b570fd3a8ce63392d54"

  option "with-tests", "run tests"
  option "with-python3", "Build against Python3 instead of Python"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "gobject-introspection"

  # these dependencies are not required for `brew test`, but rather for
  # the tests included with the source code.
  if build.with? "tests"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk+3" => :build
  end

  if build.with? "python3"
    depends_on :python3
    depends_on "py3cairo"
  else
    depends_on :python
    depends_on "py2cairo"
  end

  option :universal

  if build.with? "tests"
    patch do
      url "https://gist.githubusercontent.com/krrk/6439665/raw/a527e14cd3a77c19b089f27bea884ce46c988f55/pygobject-fix-module.patch"
      sha1 "1d7aad99256d87d616a41b7026cd05267bd9f97f"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    if build.with? "tests"
      # autogen.sh is necessary to update the build system after the above
      # patch and XDG_DATA_DIRS needs to be fixed for some tests to run
      inreplace "tests/Makefile.am", "/usr/share", HOMEBREW_PREFIX/"share"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    if build.with? "python3"
      args << "--with-python=python3"
    else
      args << "--with-python=python"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "check" if build.with? "tests"
    system "make", "clean"
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, version|
      system python, "test.py"
    end
  end
end
