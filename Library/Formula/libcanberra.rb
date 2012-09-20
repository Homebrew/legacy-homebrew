require 'formula'

class Libcanberra < Formula
  homepage 'http://0pointer.de/lennart/projects/libcanberra/'
  url 'http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.29.tar.xz'
  version '0.29'
  sha1 '74052db5d1369a52c00aa11cd2310111380345c1'

  head 'git://git.0pointer.de/libcanberra'

  depends_on 'gtk+3'
  depends_on 'gconf'
  depends_on 'libgtop'
  depends_on 'libvorbis'
  depends_on 'libogg'
  depends_on 'pulseaudio' # at least one audio backend is required
  depends_on :x11 # required if cairo depends on xcb_shm

  def patches
    DATA
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--enable-gtk3",
                          "--disable-null",
                          "--prefix=#{prefix}"

    system "make install" 
  end
end

# Remove --as-needed and --gc-sections linker flag as it causes linking to fail
__END__
diff --git a/configure b/configure
index a01b013..3b6e02c 100755
--- a/configure
+++ b/configure
@@ -5599,9 +5599,7 @@ WARNINGFLAGS=$with_cflags
 
 
 
-  for flag in \
-        -Wl,--as-needed \
-        -Wl,--gc-sections; do
+  for flag in ; do
 
   { $as_echo "$as_me:${as_lineno-$LINENO}: checking if $CC supports flag $flag in envvar LDFLAGS" >&5
 $as_echo_n "checking if $CC supports flag $flag in envvar LDFLAGS... " >&6; }
diff --git a/configure.ac b/configure.ac
index 7fe044c..03d69b6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,9 +113,7 @@ CC_CHECK_FLAGS_APPEND([with_cflags], [CFLAGS], [\
         -fdata-sections])
 AC_SUBST([WARNINGFLAGS], $with_cflags)
 
-CC_CHECK_FLAGS_APPEND([with_ldflags], [LDFLAGS], [\
-        -Wl,--as-needed \
-        -Wl,--gc-sections])
+CC_CHECK_FLAGS_APPEND([with_ldflags], [LDFLAGS], [])
 AC_SUBST([GCLDFLAGS], $with_ldflags)
 
 #### libtool stuff ####
