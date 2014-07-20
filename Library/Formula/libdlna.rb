require 'formula'

class Libdlna < Formula
  homepage 'http://libdlna.geexbox.org/'
  url 'http://libdlna.geexbox.org/releases/libdlna-0.2.4.tar.bz2'
  sha1 '5e86f4443eeb9e7194c808301efeb78611a9e8b3'

  bottle do
    cellar :any
    sha1 "349eeaa92071b050cc67926feef8e7f702b803cf" => :mavericks
    sha1 "39359e65e38a37808f6472554b1fc989c1be75fd" => :mountain_lion
    sha1 "622e348eff6fdced8617194c0d0f20a05058cf00" => :lion
  end

  depends_on 'ffmpeg'

  # Use dylib instead of soname
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 3e6f704..9701878 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,10 +21,10 @@ ifeq ($(DEVELOPER),yes)
 endif
 
 LIBNAME = libdlna
-LIBNAME_SHARED = ${LIBNAME}.so
+LIBNAME_SHARED = ${LIBNAME}.dylib
 LIBNAME_STATIC = ${LIBNAME}.a
-LIBNAME_VERSION = $(LIBNAME_SHARED).$(VERSION)
-LIBNAME_MAJOR = $(LIBNAME_SHARED).$(shell echo $(VERSION) | cut -f1 -d.)
+LIBNAME_VERSION = $(LIBNAME).$(VERSION).dylib
+LIBNAME_MAJOR = $(LIBNAME).$(shell echo $(VERSION) | cut -f1 -d.).dylib
 
 SRCS =  profiles.c \
 	containers.c \
@@ -97,8 +97,9 @@ lib_shared_info_post:
 	@echo "#############################################"
 
 lib_shared: lib_shared_info_pre $(LOBJS) lib_shared_info_post
-	$(CC) -shared -Wl,-soname,$(LIBNAME_MAJOR) $(LOBJS) \
-	  $(LDFLAGS) $(EXTRALIBS) -o $(LIBNAME_VERSION)
+	$(CC) -dynamiclib $(LOBJS) $(LDFLAGS) $(EXTRALIBS) -o $(LIBNAME_VERSION) \
+		-Wl,-install_name,$(PREFIX)/lib/$(LIBNAME_VERSION) \
+		-Wl,-compatibility_version,$(VERSION) -Wl,-current_version,$(VERSION)
 	$(LN) -sf $(LIBNAME_VERSION) $(LIBNAME_MAJOR)
 	$(LN) -sf $(LIBNAME_MAJOR) $(LIBNAME_SHARED)
 
@@ -111,7 +112,7 @@ tags:
 	 ( find -name '*.[chS]' -print ) | xargs ctags -a;
 
 clean:
-	-$(RM) -f *.o *.lo *.a *.so*
+	-$(RM) -f *.o *.lo *.a *.dylib
 	-$(RM) -f .depend
 
 install_static: lib_static
