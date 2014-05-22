require 'formula'

class Clisp < Formula
  homepage 'http://www.clisp.org/'
  url 'http://ftpmirror.gnu.org/clisp/release/2.49/clisp-2.49.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/clisp/release/2.49/clisp-2.49.tar.bz2'
  sha1 '7e8d585ef8d0d6349ffe581d1ac08681e6e670d4'

  depends_on 'libsigsegv'
  depends_on 'readline'

  fails_with :llvm do
    build 2334
    cause "Configure fails on XCode 4/Snow Leopard."
  end

  patch :DATA
  patch :p0 do
    url "https://trac.macports.org/export/89054/trunk/dports/lang/clisp/files/patch-src_lispbibl_d.diff"
    sha1 "8324152a1db755db6c66ce5c059092d55576f37b"
  end

  def install
    ENV.j1 # This build isn't parallel safe.
    ENV.O0 # Any optimization breaks the build

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV['CC'] = "#{ENV.cc} -m#{MacOS.prefer_64_bit? ? 64 : 32}"

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        s.change_make_var! 'CFLAGS', "#{s.get_make_var('CFLAGS')} #{ENV['CFLAGS']}"
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      if MacOS.version >= :lion
        opoo "`make check` fails on Lion, so we are skipping it."
        puts "But it probably means there will be other issues too."
        puts "Please take them upstream to the clisp project itself."
      else
        # Considering the complexity of this package, a self-check is highly recommended.
        system "make check"
      end

      system "make install"
    end
  end

  test do
    system "#{bin}/clisp", "--version"
  end
end

__END__
diff --git a/src/stream.d b/src/stream.d
index 5345ed6..cf14e29 100644
--- a/src/stream.d
+++ b/src/stream.d
@@ -3994,7 +3994,7 @@ global object iconv_range (object encoding, uintL start, uintL end, uintL maxint
 nonreturning_function(extern, error_unencodable, (object encoding, chart ch));
 
 /* Avoid annoying warning caused by a wrongly standardized iconv() prototype. */
-#ifdef GNU_LIBICONV
+#if defined(GNU_LIBICONV) && !defined(__APPLE_CC__)
   #undef iconv
   #define iconv(cd,inbuf,inbytesleft,outbuf,outbytesleft) \
     libiconv(cd,(ICONV_CONST char **)(inbuf),inbytesleft,outbuf,outbytesleft)
