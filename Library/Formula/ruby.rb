require 'formula'

class Ruby < Formula
  homepage 'http://www.ruby-lang.org/en/'
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p286.tar.gz'
  sha256 'e94367108751fd6bce79401d947baa66096c757fd3a0856350a2abd05d26d89d'

  head 'http://svn.ruby-lang.org/repos/ruby/trunk/'

  env :std

  option :universal
  option 'with-suffix', 'Suffix commands with "19"'
  option 'with-doc', 'Install documentation'
  option 'with-tcltk', 'Install with Tcl/Tk support'

  depends_on :autoconf if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gdbm'
  depends_on 'libyaml'
  depends_on :x11 if build.include? 'with-tcltk'

  fails_with :llvm do
    build 2326
  end

  # https://github.com/ruby/ruby/commit/2741a598ff9e561c71eb39a57bb19c0a3205eaef
  def patches; DATA end

  def install
    system "autoconf" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-shared"]

    args << "--program-suffix=19" if build.include? "with-suffix"
    args << "--with-arch=x86_64,i386" if build.universal?
    args << "--disable-tcltk-framework" <<  "--with-out-ext=tcl" <<  "--with-out-ext=tk" unless build.include? "with-tcltk"

    # Put gem, site and vendor folders in the HOMEBREW_PREFIX
    ruby_lib = HOMEBREW_PREFIX/"lib/ruby"
    (ruby_lib/'site_ruby').mkpath
    (ruby_lib/'vendor_ruby').mkpath
    (ruby_lib/'gems').mkpath

    (lib/'ruby').install_symlink ruby_lib/'site_ruby',
                                 ruby_lib/'vendor_ruby',
                                 ruby_lib/'gems'

    system "./configure", *args
    system "make"
    system "make install"
    system "make install-doc" if build.include? "with-doc"

  end

  def caveats; <<-EOS.undent
    NOTE: By default, gem installed binaries will be placed into:
      #{bin}

    You may want to add this to your PATH.
    EOS
  end
end

__END__
diff --git a/missing/setproctitle.c b/missing/setproctitle.c
index 169ba8b..4dc6d03 100644
--- a/missing/setproctitle.c
+++ b/missing/setproctitle.c
@@ -48,6 +48,12 @@
 #endif
 #include <string.h>
 
+#if defined(__APPLE__)
+#include <crt_externs.h>
+#undef environ
+#define environ (*_NSGetEnviron())
+#endif
+
 #define SPT_NONE	0	/* don't use it at all */
 #define SPT_PSTAT	1	/* use pstat(PSTAT_SETCMD, ...) */
 #define SPT_REUSEARGV	2	/* cover argv with title information */
