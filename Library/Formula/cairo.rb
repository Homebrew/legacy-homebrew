require 'formula'

class Cairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/cairo-1.12.2.tar.xz'
  sha256 'b786bc4a70542bcb09f2d9d13e5e6a0c86408cbf6d1edde5f0de807eecf93f96'

  keg_only :provided_by_osx,
    "The Cairo provided by Leopard is too old for newer software to link against." \
    if MacOS.x11_installed?

  depends_on :libpng => :recommended
  depends_on :pixman
  depends_on 'pkg-config' => :build
  depends_on 'xz'=> :build
  depends_on :x11 unless ARGV.include? '--without-x'

  def options
    [
      ['--universal', 'Build a universal library'],
      ['--without-x', 'Build without X11 support'],
    ]
  end

  # Fixes a build error with clang & universal, where a function was implicit.
  def patches; DATA; end

  def install
    ENV.universal_binary if ARGV.build_universal?

    pixman = Formula.factory('pixman')
    ENV['pixman_CFLAGS'] = "-I#{pixman.include}/pixman-1"
    ENV['pixman_LIBS'] = "-L#{pixman.lib} -lpixman-1"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}]

    args << '--with-x' unless ARGV.include? '--without-x'
    args << '--enable-xcb=no' if MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index b75757d..1230da2 100755
--- a/configure
+++ b/configure
@@ -17939,7 +17939,7 @@ CAIRO_NONPKGCONFIG_LIBS="$LIBS"
 
 MAYBE_WARN="-Wall -Wextra \
 -Wold-style-definition -Wdeclaration-after-statement \
--Wmissing-declarations -Werror-implicit-function-declaration \
+-Wmissing-declarations -Wimplicit-function-declaration \
 -Wnested-externs -Wpointer-arith -Wwrite-strings \
 -Wsign-compare -Wstrict-prototypes -Wmissing-prototypes \
 -Wpacked -Wswitch-enum -Wmissing-format-attribute \
