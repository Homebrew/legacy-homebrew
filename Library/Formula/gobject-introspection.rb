require 'formula'

class GobjectIntrospection < Formula
  homepage 'http://live.gnome.org/GObjectIntrospection'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.38/gobject-introspection-1.38.0.tar.xz'
  sha256 '3575e5d353c17a567fdf7ffaaa7aebe9347b5b0eee8e69d612ba56a9def67d73'

  option :universal
  option 'with-tests', 'run tests'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'libffi'
  if build.with? 'tests'
    depends_on 'cairo'
    depends_on :x11
  end

  # To avoid: ImportError: dlopen(./.libs/_giscanner.so, 2): Symbol not found: _PyList_Check
  depends_on :python

  if build.with? 'tests'
    # Patch to fix `make check` for OS X, changes expected '.so' extension to '.dylib'
    def patches
      "https://gist.github.com/krrk/6958869/download"
    end
  end

  def install
    ENV.universal_binary if build.universal?
    inreplace 'giscanner/transformer.py', '/usr/share', HOMEBREW_PREFIX/'share'
    inreplace 'configure' do |s|
      s.change_make_var! 'GOBJECT_INTROSPECTION_LIBDIR', HOMEBREW_PREFIX/'lib'
    end

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args <<  "--with-cairo" if build.with? 'tests'

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    To run tests install using '--with-tests' these tests require that you have cairo and XQuartz installed.
    EOS
  end

end
