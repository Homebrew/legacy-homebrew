require 'formula'

class Libcaca < Formula
  homepage 'http://caca.zoy.org/wiki/libcaca'
  url 'http://caca.zoy.org/files/libcaca/libcaca-0.99.beta17.tar.gz'
  version '0.99b17'
  md5 '790d6e26b7950e15909fdbeb23a7ea87'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  fails_with_llvm "unsupported inline asm: input constraint with a matching output constraint of incompatible type!"

  # Make libcaca build with clang; see http://caca.zoy.org/ticket/90
  def patches; DATA; end

  def install
    # Some people can't compile when Java is enabled. See:
    # https://github.com/mxcl/homebrew/issues/issue/2049

    # Don't build csharp bindings
    # Don't build ruby bindings; fails for adamv w/ Homebrew Ruby 1.9.2

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-imlib2",
                          "--disable-doc",
                          "--disable-slang",
                          "--disable-java",
                          "--disable-csharp",
                          "--disable-ruby"
    ENV.j1 # Or install can fail making the same folder at the same time
    system "make install"
  end
end

__END__
--- a/caca/caca.h 2011-07-05 00:09:51.000000000 -0700
+++ b/caca/caca.h 2011-07-05 00:10:10.000000000 -0700
@@ -645,7 +645,7 @@ typedef struct cucul_buffer cucul_buffer
 #       define CACA_DEPRECATED
 #   endif
 
-#   if defined __GNUC__ && __GNUC__ > 3
+#   if !defined __APPLE__ && defined __GNUC__ && __GNUC__ > 3
 #       define CACA_ALIAS(x) __attribute__ ((weak, alias(#x)))
 #   else
 #       define CACA_ALIAS(x)
