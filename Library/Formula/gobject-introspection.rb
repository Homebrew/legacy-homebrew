class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.48/gobject-introspection-1.48.0.tar.xz"
  sha256 "fa275aaccdbfc91ec0bc9a6fd0562051acdba731e7d584b64a277fec60e75877"

  bottle do
    revision 1
    sha256 "f74299d5504653f479d86f29239def40bcc790bfcf9a3df4ecd4ab95e2a13aab" => :el_capitan
    sha256 "e1d5345ae31ba57ccffdfb12e8499e3cfe3c69e29387c4d0765c9872f1117baa" => :yosemite
    sha256 "e3468554dddb9d16af1a15741f2734ce0aa9d87e7c81cd6a1c7161b6ef57d93c" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV.universal_binary if build.universal?
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{HOMEBREW_PREFIX}/bin/python"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert (testpath/"Tut-0.1.typelib").exist?
  end
end
