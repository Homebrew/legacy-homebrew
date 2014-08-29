require 'formula'

class Pygobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.12/pygobject-3.12.2.tar.xz'
  sha256 '7e7a3d349acf5bb4b68f8539a42e67958840a67cd4f0341ee9aa49189af2a522'

  option 'with-tests', 'run tests'

  depends_on 'pkg-config' => :build

  # these dependencies are not required for `brew test`, but rather for
  # the tests included with the source code.
  if build.with? 'tests'
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'libtool' => :build
    depends_on 'gnome-common' => :build
    depends_on 'gtk+3' => :build
  end

  depends_on 'libffi' => :optional
  depends_on 'glib'
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'py2cairo' if build.with? 'python'
  depends_on 'py3cairo' if build.with? 'python3'
  depends_on 'gobject-introspection'

  option :universal

  patch do
    url "https://gist.githubusercontent.com/krrk/6439665/raw/a527e14cd3a77c19b089f27bea884ce46c988f55/pygobject-fix-module.patch"
    sha1 "1d7aad99256d87d616a41b7026cd05267bd9f97f"
  end if build.with? 'tests'

  def install
    ENV.universal_binary if build.universal?

    if build.with? 'tests'
      # autogen.sh is necessary to update the build system after the above
      # patch and XDG_DATA_DIRS needs to be fixed for some tests to run
      inreplace 'tests/Makefile.am', '/usr/share', HOMEBREW_PREFIX/'share'
      system "./autogen.sh"
    end

    Language::Python.each_python(build) do |python, version|
      ENV["PYTHON"] = "#{python}" if Formula[python].installed?
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
      system "make", "check" if build.with? 'tests'
      system "make", "clean"
    end
  end

  test do
    Pathname('test.py').write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, version|
      system python, "test.py"
    end
  end
end
