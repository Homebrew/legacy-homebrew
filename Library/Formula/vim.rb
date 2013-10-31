require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  # This package tracks debian-unstable: http://packages.debian.org/unstable/vim
  url 'http://ftp.debian.org/debian/pool/main/v/vim/vim_7.4.052.orig.tar.gz'
  sha1 '216ab69faf7e73e4b86da7f00e4ad3b3cca1fdb8'

  head 'https://vim.googlecode.com/hg/'

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  env :std

  option "override-system-vi", "Override system vi"
  option "disable-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w(lua mzscheme perl tcl)
  LANGUAGES_DEFAULT  = %w(ruby python)

  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on 'lua' => :optional
  depends_on 'gtk+' if build.with? 'client-server'

  # First patch: vim uses the obsolete Apple-only -no-cpp-precomp flag, which
  # FSF GCC can't understand; reported upstream:
  # https://groups.google.com/forum/#!topic/vim_dev/X5yG3-IiUp8
  #
  # Second patch: includes Mac OS X version macros not included by default on 10.9
  # Reported upstream: https://groups.google.com/forum/#!topic/vim_mac/5kVAMSPb6uU
  def patches; DATA; end

  def install
    ENV['LUA_PREFIX'] = HOMEBREW_PREFIX if build.with?('lua')

    opts = []
    opts += LANGUAGES_OPTIONAL.map do |language|
      "--enable-#{language}interp" if build.with? language
    end
    opts += LANGUAGES_DEFAULT.map do |language|
      "--enable-#{language}interp" unless build.without? language
    end

    opts << "--disable-nls" if build.include? "disable-nls"

    if python
      if python.brewed?
        # Avoid that vim always links System's Python even if configure tells us
        # it has found a brewed Python. Verify with `otool -L`.
        ENV.prepend 'LDFLAGS', "-F#{python.framework}"
      elsif python.from_osx? && !MacOS::CLT.installed?
        # Avoid `Python.h not found` on 10.8 with Xcode-only
        ENV.append 'CFLAGS', "-I#{python.incdir}", ' '
        # opts << "--with-python-config-dir=#{python.libdir}"
      end
    end

    if build.with? 'client-server'
      opts << '--enable-gui=gtk2'
    else
      opts << "--enable-gui=no"
      opts << "--without-x"
    end

    # XXX: Please do not submit a pull request that hardcodes the path
    # to ruby: vim can be compiled against 1.8.x or 1.9.3-p385 and up.
    # If you have problems with vim because of ruby, ensure a compatible
    # version is first in your PATH when building vim.

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-features=huge",
                          "--with-compiledby=Homebrew",
                          *opts
    system "make"
    # If stripping the binaries is not enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=/usr/bin/true"
    ln_s bin+'vim', bin+'vi' if build.include? 'override-system-vi'
  end
end

__END__
diff --git a/src/auto/configure b/src/auto/configure
index 07f794e..5736d80 100755
--- a/src/auto/configure
+++ b/src/auto/configure
@@ -4221,7 +4221,7 @@ rm -f core conftest.err conftest.$ac_objext \
     MACOSX=yes
     OS_EXTRA_SRC="os_macosx.m os_mac_conv.c";
     OS_EXTRA_OBJ="objects/os_macosx.o objects/os_mac_conv.o"
-        CPPFLAGS="$CPPFLAGS -DMACOS_X_UNIX -no-cpp-precomp"
+        CPPFLAGS="$CPPFLAGS -DMACOS_X_UNIX"
 
                 # On IRIX 5.3, sys/types and inttypes.h are conflicting.
 for ac_header in sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h \
@@ -4298,7 +4298,7 @@ fi
 
   if test "$GCC" = yes -a "$local_dir" != no; then
     echo 'void f(){}' > conftest.c
-        have_local_include=`${CC-cc} -no-cpp-precomp -c -v conftest.c 2>&1 | grep "${local_dir}/include"`
+        have_local_include=`${CC-cc} -c -v conftest.c 2>&1 | grep "${local_dir}/include"`
     have_local_lib=`${CC-cc} -c -v conftest.c 2>&1 | grep "${local_dir}/lib"`
     rm -f conftest.c conftest.o
   fi
diff --git a/src/osdef.sh b/src/osdef.sh
index d7d4f2a..7015d7b 100755
--- a/src/osdef.sh
+++ b/src/osdef.sh
@@ -49,7 +49,6 @@ EOF
 
 # Mac uses precompiled headers, but we need real headers here.
 case `uname` in
-    Darwin)	$CC -I. -I$srcdir -E -no-cpp-precomp osdef0.c >osdef0.cc;;
     *)		$CC -I. -I$srcdir -E osdef0.c >osdef0.cc;;
 esac
 

diff --git a/src/os_mac.h b/src/os_mac.h
index 78b79c2..54009ab 100644
--- a/src/os_mac.h
+++ b/src/os_mac.h
@@ -16,6 +16,9 @@
 # define OPAQUE_TOOLBOX_STRUCTS 0
 #endif
 
+/* Include MAC_OS_X_VERSION_* macros */
+#include <AvailabilityMacros.h>
+
 /*
  * Macintosh machine-dependent things.
  *
