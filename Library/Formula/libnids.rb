require 'formula'

class Libnids < Formula
  homepage 'http://libnids.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz'
  sha1 '9a421df05cefdc4f5f7db95efc001b3c2b5249ce'

  option "disable-libnet", "Don't include code requiring libnet"
  option "disable-libglib", "Don't use glib2 for multiprocessing support"

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :libtool
  depends_on 'libnet' unless build.include? "disable-libnet"
  depends_on 'glib' unless build.include? "disable-libglib"

  # Patch fixes -soname and .so shared library issues. Unreported.
  def patches
    DATA
  end

  def install
    # autoreconf the old 2005 era code for sanity.
    system 'autoreconf', '-ivf'
    args = ["--prefix=#{prefix}", "--mandir=#{man}", "--enable-shared"]
    args << "--disable-libnet" if build.include? "disable-libnet"
    args << "--disable-libglib" if build.include? "disable-libglib"

    system "./configure", *args
    system "make install"
  end
end

__END__
--- a/src/Makefile.in	2010-03-01 13:13:17.000000000 -0800
+++ b/src/Makefile.in	2012-09-19 09:48:23.000000000 -0700
@@ -13,7 +13,7 @@
 libdir		= @libdir@
 mandir		= @mandir@
 LIBSTATIC      = libnids.a
-LIBSHARED      = libnids.so.1.24
+LIBSHARED      = libnids.1.24.dylib
 
 CC		= @CC@
 CFLAGS		= @CFLAGS@ -DLIBNET_VER=@LIBNET_VER@ -DHAVE_ICMPHDR=@ICMPHEADER@ -DHAVE_TCP_STATES=@TCPSTATES@ -DHAVE_BSD_UDPHDR=@HAVE_BSD_UDPHDR@
@@ -65,7 +65,7 @@
 	ar -cr $@ $(OBJS)
 	$(RANLIB) $@
 $(LIBSHARED): $(OBJS_SHARED)
-	$(CC) -shared -Wl,-soname,$(LIBSHARED) -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
+	$(CC) -dynamiclib -Wl,-dylib -Wl,-install_name,$(LIBSHARED) -Wl,-headerpad_max_install_names -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
 
 _install install: $(LIBSTATIC)
 	../mkinstalldirs $(install_prefix)$(libdir)
@@ -76,7 +76,7 @@
 	$(INSTALL) -c -m 644 libnids.3 $(install_prefix)$(mandir)/man3
 _installshared installshared: install $(LIBSHARED)
 	$(INSTALL) -c -m 755 $(LIBSHARED) $(install_prefix)$(libdir)
-	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.so
+	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.dylib
  
 clean:
 	rm -f *.o *~ $(LIBSTATIC) $(LIBSHARED)
