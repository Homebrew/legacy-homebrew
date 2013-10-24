require 'formula'

class Fish < Formula
  homepage 'http://fishshell.com'
  url 'http://fishshell.com/files/2.0.0/fish-2.0.0.tar.gz'
  sha1 '2d28553e2ff975f8e5fed6b266f7a940493b6636'

  head 'https://github.com/fish-shell/fish-shell.git'

  # Indeed, the head build always builds documentation
  depends_on 'doxygen' => :build if build.head?
  depends_on :autoconf

  skip_clean 'share/doc'

  # Don't search extra folders for libiconv
  def patches; DATA; end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "fish", "-c", "echo"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 34f25e1..b9afa51 100644
--- a/configure.ac
+++ b/configure.ac
@@ -98,45 +98,6 @@ AC_PROG_INSTALL
 
 echo "CXXFLAGS: $CXXFLAGS"
 
-#
-# Detect directories which may contain additional headers, libraries
-# and commands. This needs to be done early - before Autoconf starts
-# to mess with CFLAGS and all the other environemnt variables.
-#
-# This mostly helps OS X users, since fink usually installs out of
-# tree and doesn't update CFLAGS.
-#
-# It also helps FreeBSD which puts libiconv in /usr/local/lib
-
-for i in /usr/pkg /sw /opt /opt/local /usr/local; do
-
-  AC_MSG_CHECKING([for $i/include include directory])
-  if test -d $i/include; then
-    AC_MSG_RESULT(yes)
-    CXXFLAGS="$CXXFLAGS -I$i/include/"
-    CFLAGS="$CFLAGS -I$i/include/"
-  else
-  AC_MSG_RESULT(no)
-  fi
-
-  AC_MSG_CHECKING([for $i/lib library directory])
-  if test -d $i/lib; then
-    AC_MSG_RESULT(yes)
-    LDFLAGS="$LDFLAGS -L$i/lib/ -Wl,-rpath,$i/lib/"
-  else
-    AC_MSG_RESULT(no)
-  fi
-
-  AC_MSG_CHECKING([for $i/bin command directory])
-  if test -d $i/bin; then
-    AC_MSG_RESULT(yes)
-    optbindirs="$optbindirs $i/bin"
-  else
-    AC_MSG_RESULT(no)
-  fi
-
-done
-
 
 #
 # Tell autoconf to create config.h header
