class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "http://libnids.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"

  bottle do
    cellar :any
    revision 1
    sha1 "49f12f0277e954aad59221c16f28d1ac86838ea1" => :yosemite
    sha1 "fcb4eed5e69d8f80e5f7bacd6dad1d09d942e4f7" => :mavericks
    sha1 "23f8aaac028f2fd18323cebd0f5e06c74e708893" => :mountain_lion
  end

  deprecated_option "disable-libnet" => "without-libnet"
  deprecated_option "disable-libglib" => "without-glib"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libnet" => :recommended
  depends_on "glib" => :recommended

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch :DATA

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    args = ["--prefix=#{prefix}", "--mandir=#{man}", "--enable-shared"]
    args << "--disable-libnet" if build.without? "libnet"
    args << "--disable-libglib" if build.without? "glib"

    system "./configure", *args
    system "make", "install"
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
