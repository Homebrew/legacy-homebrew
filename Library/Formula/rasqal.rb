require 'formula'

class Rasqal <Formula
  url 'http://download.librdf.org/source/rasqal-0.9.19.tar.gz'
  homepage 'http://librdf.org/rasqal/'
  md5 '9bc1b40ffe1bdc794887d845d153bd4e'

  depends_on 'raptor'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

__END__

Index: rasqal-0.9.19/configure
===================================================================
--- rasqal-0.9.19.orig/configure	2010-07-06 21:10:32.000000000 -0500
+++ rasqal-0.9.19/configure		2010-07-06 21:10:41.000000000 -0500
@@ -11950,7 +11950,7 @@
     RAPTOR_MAX_VERSION_DEC=`echo $RAPTOR_MAX_VERSION | $AWK -F. '{printf("%d\n", 10000*$1 + 100*$2 + $3)};'`
 
     if test "X$with_raptor" = Xauto; then
-      if test "X$RAPTOR_VERSION" -a $RAPTOR_VERSION_DEC -ge $RAPTOR_MIN_VERSION_DEC -a $RAPTOR_VERSION_DEC -le $RAPTOR_MAX_VERSION; then
+      if test "X$RAPTOR_VERSION" -a $RAPTOR_VERSION_DEC -ge $RAPTOR_MIN_VERSION_DEC -a $RAPTOR_VERSION_DEC -le $RAPTOR_MAX_VERSION_DEC; then
 	with_raptor=system
       else
         { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: System raptor $RAPTOR_VERSION is not in supported range - $RAPTOR_MIN_VERSION to $RAPTOR_MAX_VERSION" >&5
