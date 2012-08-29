require 'formula'

class MinisatCBindings < Formula
  url 'https://github.com/niklasso/minisat-c-bindings/tarball/master'
  homepage 'http://minisat.se'
  version 'master'

  depends_on 'minisat'

  def patches
	DATA
  end

  def install
        system "make config prefix=#{prefix}"
	system "make install"
  end

end

__END__
diff --git a/Makefile b/Makefile
index 79c7779..0837570 100644
--- a/Makefile
+++ b/Makefile
@@ -54,7 +54,7 @@ mandir      ?= $(datarootdir)/man
 
 # Target file names
 MBINDC_SLIB = libminisat-c.a#  Name of MiniSat C-bindings static library.
-MBINDC_DLIB = libminisat-c.so# Name of MiniSat C-bindings shared library.
+MBINDC_DLIB = libminisat-c.dylib# Name of MiniSat C-bindings shared library.
 
 # Shared Library Version
 SOMAJOR=1
@@ -124,7 +124,7 @@ $(BUILD_DIR)/dynamic/%.o:	%.cc
 $(BUILD_DIR)/dynamic/lib/$(MBINDC_DLIB).$(SOMAJOR).$(SOMINOR)$(SORELEASE):
 	$(ECHO) echo Linking Shared Library: $@
 	$(VERB) mkdir -p $(dir $@)
-	$(VERB) $(CXX) -o $@ -shared -Wl,-soname,$(MBINDC_DLIB).$(SOMAJOR) $^ $(MBINDC_LDFLAGS)
+	$(VERB) $(CXX) -o $@ -shared -Wl,-install_name,$(MBINDC_DLIB).$(SOMAJOR) $^ $(MBINDC_LDFLAGS)
 
 install:	install-headers install-lib install-lib-static
 install-static:	install-headers install-lib-static
