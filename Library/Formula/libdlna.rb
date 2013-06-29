require 'formula'

class Libdlna < Formula
  homepage 'http://libdlna.geexbox.org/'
  url 'http://libdlna.geexbox.org/releases/libdlna-0.2.4.tar.bz2'
  sha1 '5e86f4443eeb9e7194c808301efeb78611a9e8b3'

  depends_on 'ffmpeg'

  # Use dylib instead of soname
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 3e6f704..c31f4e5 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,7 @@ ifeq ($(DEVELOPER),yes)
 endif
 
 LIBNAME = libdlna
-LIBNAME_SHARED = ${LIBNAME}.so
+LIBNAME_SHARED = ${LIBNAME}.dylib
 LIBNAME_STATIC = ${LIBNAME}.a
 LIBNAME_VERSION = $(LIBNAME_SHARED).$(VERSION)
 LIBNAME_MAJOR = $(LIBNAME_SHARED).$(shell echo $(VERSION) | cut -f1 -d.)
@@ -97,8 +97,7 @@ lib_shared_info_post:
 	@echo "#############################################"
 
 lib_shared: lib_shared_info_pre $(LOBJS) lib_shared_info_post
-	$(CC) -shared -Wl,-soname,$(LIBNAME_MAJOR) $(LOBJS) \
-	  $(LDFLAGS) $(EXTRALIBS) -o $(LIBNAME_VERSION)
+	$(CC) -dynamiclib -install_name $(PREFIX)/lib/$(LIBNAME_SHARED) $(LOBJS) $(LDFLAGS) $(EXTRALIBS) -o $(LIBNAME_VERSION) -compatibility_version $(VERSION) -current_version $(VERSION)
 	$(LN) -sf $(LIBNAME_VERSION) $(LIBNAME_MAJOR)
 	$(LN) -sf $(LIBNAME_MAJOR) $(LIBNAME_SHARED)
 
@@ -111,7 +110,7 @@ tags:
 	 ( find -name '*.[chS]' -print ) | xargs ctags -a;
 
 clean:
-	-$(RM) -f *.o *.lo *.a *.so*
+	-$(RM) -f *.o *.lo *.a *.dylib*
 	-$(RM) -f .depend
 
 install_static: lib_static
