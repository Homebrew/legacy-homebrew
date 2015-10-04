class Pygobject3 < Formula
  desc "GLib/GObject/GIO Python bindings for Python 3"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.18/pygobject-3.18.0.tar.xz"
  sha256 "1c3ba1112d3713cd5c86260312bfeb0de1f84f18808e51072c50b29d46156dc9"

  bottle do
    sha256 "62d07f2c2358f218b550529be214120c27d8aa17110ee432007306505650bd45" => :el_capitan
    sha256 "22463499593a38fec4ed389992c122b6024ddcd9e1ca8d896b31148779d8388f" => :yosemite
    sha256 "5bc154b74662f36df70f3bfa88c58196856bc1c835bd5251b3fb27424a252fd5" => :mavericks
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
