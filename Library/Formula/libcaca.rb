require 'formula'

class Libcaca < Formula
  homepage 'http://caca.zoy.org/wiki/libcaca'
  url 'http://caca.zoy.org/files/libcaca/libcaca-0.99.beta18.tar.gz'
  version '0.99b18'
  sha1 '0cbf8075c01d59b53c3cdfec7df9818696a41128'

  option 'with-imlib2', 'Build with Imlib2 support'

  depends_on :x11 if MacOS::X11.installed? or build.include? "with-imlib2"

  if build.include? "with-imlib2"
    depends_on 'pkg-config' => :build
    depends_on 'imlib2' => :optional
  end

  fails_with :llvm do
    cause "Unsupported inline asm: input constraint with a matching output constraint of incompatible type"
  end

  # Make libcaca build with clang; see http://caca.zoy.org/ticket/90
  def patches; DATA; end

  def install
    # Some people can't compile when Java is enabled. See:
    # https://github.com/mxcl/homebrew/issues/issue/2049

    # Don't build csharp bindings
    # Don't build ruby bindings; fails for adamv w/ Homebrew Ruby 1.9.2
    # Don't build python bindings:
    #   ../.auto/py-compile: Missing argument to --destdir.

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-python",
                          "--disable-doc",
                          "--disable-slang",
                          "--disable-java",
                          "--disable-csharp",
                          "--disable-ruby"
    system "make"
    ENV.j1 # Or install can fail making the same folder at the same time
    system "make install"
  end

  def test
    system "#{bin}/img2txt", "--version"
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
