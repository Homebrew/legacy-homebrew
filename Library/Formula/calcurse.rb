require 'formula'

class Calcurse < Formula
  url 'http://culot.org/cgi-bin/get.cgi?calcurse-2.7.tar.gz'
  homepage 'http://culot.org/calcurse/'
  md5 'eddfae36370fd89532149fe80c312e1e'

  depends_on 'gettext'

  def patches
    DATA
  end

  def install
    ENV.append 'CFLAGS', "-I#{include} -fnested-functions"
    ENV.append 'LDFLAGS', "-lintl"
    ENV.O3
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end

end
__END__
diff --git a/configure b/configure
index 69d2800..175871e 100755
--- a/configure
+++ b/configure
@@ -1488,7 +1488,8 @@ else
   if test -f "$ac_aux_dir/mkinstalldirs"; then
     mkdir_p='$(mkinstalldirs)'
   else
-    mkdir_p='$(SHELL) $(install_sh) -d'
+    #mkdir_p='$(SHELL) $(install_sh) -d'
+    mkdir_p='$(install_sh) -d'
   fi
 fi
 
@@ -1706,7 +1707,8 @@ else
 fi
 
 fi
-INSTALL_STRIP_PROGRAM="\${SHELL} \$(install_sh) -c -s"
+#INSTALL_STRIP_PROGRAM="\${SHELL} \$(install_sh) -c -s"
+INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
 
 # We need awk for the "check" target.  The system "awk" is bad on
 # some platforms.
