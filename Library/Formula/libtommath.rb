require 'formula'

class Libtommath < Formula
  url 'https://github.com/libtom/libtommath/zipball/v0.42.0'
  homepage 'http://libtom.org/?page=features&whatfile=ltm'
  md5 '87b053ba9f150770b5c038f6122bbb0d'

  def install
    inreplace 'makefile' do |s|
      s.change_make_var! "LIBPATH", lib
    end

    system "make"

    lib.install %w{libtommath.a libtommath.0.42.0.dylib}
    doc.install %w{LICENSE changes.txt}
    include.install %w{tommath.h tommath_class.h tommath_superclass.h}

    ln_s "#{lib}/libtommath.0.42.0.dylib", "#{lib}/libtommath.0.dylib"
    ln_s "#{lib}/libtommath.0.42.0.dylib", "#{lib}/libtommath.dylib"
  end

  def patches
    # Based off the macport
    DATA
  end
end

__END__
diff --git a/makefile b/makefile
index 70de306..b734b4b 100644
--- a/makefile
+++ b/makefile
@@ -45,7 +45,7 @@ ifndef LIBNAME
    LIBNAME=libtommath.a
 endif
 
-default: ${LIBNAME}
+default: libtommath.$(VERSION).dylib ${LIBNAME}
 
 HEADERS=tommath.h tommath_class.h tommath_superclass.h
 
@@ -89,6 +89,9 @@ $(LIBNAME):  $(OBJECTS)
 	$(AR) $(ARFLAGS) $@ $(OBJECTS)
 	ranlib $@
 
+libtommath.$(VERSION).dylib: $(OBJECTS)
+	$(CC) -fno-common -dynamiclib -o $@ $(OBJECTS) -install_name $(LIBPATH)/$@
+
 #make a profiled library (takes a while!!!)
 #
 # This will build the library with profile generation
