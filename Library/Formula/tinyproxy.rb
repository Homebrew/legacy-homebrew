require 'formula'

class Tinyproxy < Formula
  url 'https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.2.tar.bz2'
  homepage 'https://www.banu.com/tinyproxy/'
  md5 'edc8502193cfed4974d6a770da173755'

  skip_clean 'var/run'

  depends_on 'asciidoc'

  def patches
     # fixes LF_FLAGS ld -z not recognized
     DATA
  end

  def install
    #inreplace 'doc/tinyproxy.conf' do |s|
    #  s.gsub! '/var', var
    #  s.gsub! '/usr/share', share
    #end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-regexcheck=no"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 79e7938..2aa5347 100755
--- a/configure
+++ b/configure
@@ -6745,7 +6745,6 @@ if test x"$debug_enabled" != x"yes" ; then
     CFLAGS="-DNDEBUG $CFLAGS"
 fi
 
-LDFLAGS="-Wl,-z,defs"
 
 
 if test x"$ac_cv_func_regexec" != x"yes"; then
