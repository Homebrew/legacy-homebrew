class GobjectIntrospection < Formula
  desc "Generate interface introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.44/gobject-introspection-1.44.0.tar.xz"
  sha256 "6f0c2c28aeaa37b5037acbf21558098c4f95029b666db755d3a12c2f1e1627ad"

  bottle do
    revision 2
    sha256 "2b70ddf6f20e91dbded15f54fbf770879e815a677f8eb9eec0f587b31aa1c17c" => :el_capitan
    sha256 "e29497a4aa084f25f7d53988beab1999c4b3145896f0ef6a993b0d7736269cbd" => :yosemite
    sha256 "1e0e84d4d114f39d89549bc5a6bfae59a84655a1aefce926d8dd6e53495390ae" => :mavericks
    sha256 "3dcfedfe989ec4d9c6558def0190ef3bd3214bafa4d2f53fd28aa1abbc1403f2" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "libffi"

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

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
