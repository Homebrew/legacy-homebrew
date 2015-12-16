class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.46/gobject-introspection-1.46.0.tar.xz"
  sha256 "6658bd3c2b8813eb3e2511ee153238d09ace9d309e4574af27443d87423e4233"
  revision 1

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
  # System python in Mavericks or below has bug in distutils/sysconfig.py, which breaks the install.
  #    Caught exception: <type 'exceptions.AttributeError'> AttributeError("'NoneType' object has no attribute 'get'",)
  #    > /System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/sysconfig.py(171)customize_compiler()
  depends_on "python" if MacOS.version <= :mavericks

  # see https://bugzilla.gnome.org/show_bug.cgi?id=625195
  # to be removed when 1.48.0 is released
  patch do
    url "https://github.com/GNOME/gobject-introspection/commit/4a724ac699f0c34fba2fb452cfadea11540325e8.patch"
    sha256 "047c350bad2d222f1037c3ce1889444ebc1095df76120188037c4eb2900848c4"
  end

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

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=python"
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
