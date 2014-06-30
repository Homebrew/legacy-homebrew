require 'formula'

class GobjectIntrospection < Formula
  homepage 'http://live.gnome.org/GObjectIntrospection'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.40/gobject-introspection-1.40.0.tar.xz'
  sha256 '96ea75e9679083e7fe39a105e810e2ead2d708abf189a5ba420bfccfffa24e98'

  bottle do
    sha1 "dbd65331012abd0570bfb8b115870a4ece51aad7" => :mavericks
    sha1 "e553b3f537e998ef50ca42f1224aa981558ee29d" => :mountain_lion
    sha1 "bb2353a61e8a05d4ef3e2a9f113d8ff348106e79" => :lion
  end

  option :universal
  option 'with-tests', 'Run tests in addition to the build (requires cairo)'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libffi'
  # To avoid: ImportError: dlopen(./.libs/_giscanner.so, 2): Symbol not found: _PyList_Check
  depends_on :python
  depends_on 'cairo' => :build if build.with? 'tests'

  # Allow tests to execute on OS X (.so => .dylib)
  patch do
    url "https://gist.githubusercontent.com/krrk/6958869/raw/de8d83009d58eefa680a590f5839e61a6e76ff76/gobject-introspection-tests.patch"
    sha1 "1f57849db76cd2ca26ddb35dc36c373606414dfc"
  end if build.with? "tests"

  def install
    ENV['GI_SCANNER_DISABLE_CACHE'] = 'true'
    ENV.universal_binary if build.universal?
    inreplace 'giscanner/transformer.py', '/usr/share', HOMEBREW_PREFIX/'share'
    inreplace 'configure' do |s|
      s.change_make_var! 'GOBJECT_INTROSPECTION_LIBDIR', HOMEBREW_PREFIX/'lib'
    end

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-cairo" if build.with? "tests"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "tests"
    system "make", "install"
  end
end
