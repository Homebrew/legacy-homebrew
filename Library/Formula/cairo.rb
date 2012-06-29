require 'formula'

class Cairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.10.2.tar.gz'
  sha1 'ccce5ae03f99c505db97c286a0c9a90a926d3c6e'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only :provided_by_osx,
            "The Cairo provided by Leopard is too old for newer software to link against."

  def options
    [['--universal', 'Build a universal library']]
  end

  # Fixes a build error with llvm, 'lto could not merge'.  Fixes a build error
  # when brewing universal, cannot use 'lto-bc' with multiple -arch options.
  # Fixes a build error with clang & universal, where a function was implicit.
  # Not reported upstream because we are using an old version, Cairo-1.10.2.
  # cf. issues #12923 and #10400
  def patches; DATA; end

  def install
    ENV.universal_binary if ARGV.include? '--universal'
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-x
    ]
    args << '--enable-xcb' unless MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end

__END__
--- a/configure	2010-12-25 06:22:57.000000000 -0800
+++ b/configure	2012-06-19 22:39:49.000000000 -0700
@@ -17224,7 +17224,7 @@
 
 MAYBE_WARN="-Wall -Wextra \
 -Wold-style-definition -Wdeclaration-after-statement \
--Wmissing-declarations -Werror-implicit-function-declaration \
+-Wmissing-declarations -Wimplicit-function-declaration \
 -Wnested-externs -Wpointer-arith -Wwrite-strings \
 -Wsign-compare -Wstrict-prototypes -Wmissing-prototypes \
 -Wpacked -Wswitch-enum -Wmissing-format-attribute \
@@ -17236,7 +17236,7 @@
 MAYBE_WARN="$MAYBE_WARN -erroff=E_ENUM_TYPE_MISMATCH_ARG \
 			-erroff=E_ENUM_TYPE_MISMATCH_OP"
 
-MAYBE_WARN="$MAYBE_WARN -fno-strict-aliasing -fno-common -flto"
+MAYBE_WARN="$MAYBE_WARN -fno-strict-aliasing -fno-common"
 
 MAYBE_WARN="$MAYBE_WARN -Wp,-D_FORTIFY_SOURCE=2"
 
