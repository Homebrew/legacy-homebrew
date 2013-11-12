require 'formula'

class Libsoil < Formula
  homepage 'https://github.com/smibarber/libSOIL'
  url 'https://codeload.github.com/smibarber/libSOIL/zip/master'
  version '1.07'
  sha1 'a42baf594c02bdeeffed9fda4f0666bf3bd1725a'

  def patches
    DATA
  end

  def install
    system "make", "lib"
    include.install "SOIL.h"
    lib.install "libSOIL.a"
    lib.install "libSOIL.dylib"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 6844aa6..8c1a093 100755
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@ lib: $(OFILES)
 	ar -cvq $(LIBNAME).a $(OFILES)
 	# create shared library
 	gcc -dynamiclib -o $(DYLIBFILE) $(OFILES) $(LDFLAGS)\
-	 	-install_name $(DESTDIR)/$(LIBDIR)/$(DYLIBFILE)
+	 	-install_name /$HOMEBREW_PREFIX/libsoil/1.07/$(DYLIBFILE)
 
 install:
 	$(INSTALL_DIR) $(DESTDIR)/$(INCLUDEDIR)
