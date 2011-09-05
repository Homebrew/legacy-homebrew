require 'formula'

class Nettle < Formula
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.4.tar.gz'
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  md5 '450be8c4886d46c09f49f568ad6fa013'

  depends_on 'gmp'

  # Fix undefined symbols when linking
  def patches; DATA; end

  def install
    ENV.universal_binary
    ENV.append 'LDFLAGS', '-lgmp' # Fix undefined symbols when linking
    ENV['DYLD_LIBRARY_PATH'] = lib # otherwise 'make check' fails

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-assembler"
    system "make"
    system "make install"
    system "make check"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index fd486f5..227ccd9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -163,7 +163,7 @@ $(LIBNETTLE_FORLINK): $(nettle_PURE_OBJS)
           && ln -sf ../$(LIBNETTLE_FORLINK) $(LIBNETTLE_SONAME))
 
 $(LIBHOGWEED_FORLINK): $(hogweed_PURE_OBJS) $(LIBNETTLE_FORLINK)
-	$(LIBHOGWEED_LINK) $(hogweed_PURE_OBJS) -o $@ $(LIBHOGWEED_LIBS)
+	$(LIBHOGWEED_LINK) $(hogweed_PURE_OBJS) $(nettle_PURE_OBJS) -o $@ $(LIBHOGWEED_LIBS)
 	-mkdir .lib 2>/dev/null
 	[ -z "$(LIBHOGWEED_SONAME)" ] || (cd .lib \
           && ln -sf ../$(LIBHOGWEED_FORLINK) $(LIBHOGWEED_SONAME))
