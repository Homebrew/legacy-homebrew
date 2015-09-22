class Pygobject3 < Formula
  desc "GLib/GObject/GIO Python bindings for Python 3"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.18/pygobject-3.18.0.tar.xz"
  sha256 "1c3ba1112d3713cd5c86260312bfeb0de1f84f18808e51072c50b29d46156dc9"

  bottle do
    sha256 "94b5cacf8c2a265e8086c9037d376ff7008f50de2d68b346cc08750ffda94f1d" => :el_capitan
    sha256 "75149598f8cf980feafe170e6ba007f6e75e774a2ed2a5539d5df70cdb458735" => :yosemite
    sha256 "26d501f9063231c6c77bc72298f0cb8b05c22226cbdca2df55b84f5f1aaed02c" => :mavericks
    sha256 "c3b842901e70cf25698ba203f2137f757d62cee06cfb90007cdf04265ac523ae" => :mountain_lion
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
