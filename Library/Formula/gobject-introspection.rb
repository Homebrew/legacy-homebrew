class GobjectIntrospection < Formula
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.44/gobject-introspection-1.44.0.tar.xz"
  sha256 "6f0c2c28aeaa37b5037acbf21558098c4f95029b666db755d3a12c2f1e1627ad"

  bottle do
    sha256 "c5a08e5ac31a4524d1322158f404a4b42a08e43e3716621b9e0bf905aacf46d1" => :yosemite
    sha256 "095dafa25ce514912c9ecd6211e809976a67473ea8d9c1c862d707c7e80cc903" => :mavericks
    sha256 "1c9c9a5caab3d1453a4cfb12a1e167e673eb953eb20c2a15953bd50f9f7793be" => :mountain_lion
  end

  option :universal
  option "with-tests", "Run tests in addition to the build (requires cairo)"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libffi"
  # To avoid: ImportError: dlopen(./.libs/_giscanner.so, 2): Symbol not found: _PyList_Check
  depends_on :python
  depends_on "cairo" => :build if build.with? "tests"

  # Allow tests to execute on OS X (.so => .dylib)
  patch do
    url "https://gist.githubusercontent.com/krrk/6958869/raw/de8d83009d58eefa680a590f5839e61a6e76ff76/gobject-introspection-tests.patch"
    sha1 "1f57849db76cd2ca26ddb35dc36c373606414dfc"
  end if build.with? "tests"

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV.universal_binary if build.universal?
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-cairo" if build.with? "tests"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "tests"
    system "make", "install"
  end

  test do
    system bin/"g-ir-annotation-tool", "--help"
  end
end
