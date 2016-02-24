class Pygobject3 < Formula
  desc "GLib/GObject/GIO Python bindings for Python 3"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.18/pygobject-3.18.2.tar.xz"
  sha256 "2a3cad1517916b74e131e6002c3824361aee0671ffb0d55ded119477fc1c2c5f"

  bottle do
    sha256 "28dd19d1d32f8890d246b0e98fbb788438ee753f85e880eb754044752bc3e322" => :el_capitan
    sha256 "bf85d0cccf9311f91909886745a6ea330868f2dff1045e8f2d53c01ae0531bc7" => :yosemite
    sha256 "133386638620543280a54cbfe5ed9982b1a55fdeb79e33ab3c3516fb3e6a8033" => :mavericks
  end

  option :universal
  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?

    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
