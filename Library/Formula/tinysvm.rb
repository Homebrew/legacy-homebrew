require 'formula'

class Tinysvm < Formula
  homepage 'http://chasen.org/~taku/software/TinySVM/'
  url 'http://chasen.org/~taku/software/TinySVM/src/TinySVM-0.09.tar.gz'
  md5 '22d80bdd94c3c8373062761de0d27fde'

  def patches
    # some minor fixes needed to build on OSX
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install" 
  end

  def test
    system "svm_learn --help"
    system "svm_classify --help"
    system "svm_model --help"
  end
end

__END__
diff --git a/configure b/configure
index e2df3f9..0d93f5d 100755
--- a/configure
+++ b/configure
@@ -3858,7 +3858,7 @@ else
     # FIXME: Relying on posixy $() will cause problems for
     #        cross-compilation, but unfortunately the echo tests do not
     #        yet detect zsh echo's removal of \ escapes.
-    archive_cmds='$CC $(test .$module = .yes && echo -bundle || echo -dynamiclib) $allow_undefined_flag -o $lib $libobjs $deplibs$linkopts -install_name $rpath/$soname $(test -n "$verstring" -a x$verstring != x0.0 && echo $verstring)'
+    archive_cmds='$CXX $(test .$module = .yes && echo -bundle || echo -dynamiclib) $allow_undefined_flag -o $lib $libobjs $deplibs$linkopts -install_name $rpath/$soname $(test -n "$verstring" -a x$verstring != x0.0 && echo $verstring)'
     # We need to add '_' to the symbols in $export_symbols first
     #archive_expsym_cmds="$archive_cmds"' && strip -s $export_symbols'
     hardcode_direct=yes
diff --git a/src/getopt.h b/src/getopt.h
index fa79ccf..585b759 100644
--- a/src/getopt.h
+++ b/src/getopt.h
@@ -122,14 +122,7 @@ struct option
 #define optional_argument	2
 
 #if defined (__STDC__) && __STDC__
-#ifdef __GNU_LIBRARY__
-/* Many other libraries have conflicting prototypes for getopt, with
-   differences in the consts, in stdlib.h.  To avoid compilation
-   errors, only prototype getopt for the GNU C library.  */
 extern int getopt (int argc, char *const *argv, const char *shortopts);
-#else /* not __GNU_LIBRARY__ */
-extern int getopt ();
-#endif /* __GNU_LIBRARY__ */
 extern int getopt_long (int argc, char *const *argv, const char *shortopts,
 		        const struct option *longopts, int *longind);
 extern int getopt_long_only (int argc, char *const *argv,

