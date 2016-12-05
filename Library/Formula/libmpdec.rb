class Libmpdec < Formula
  desc "Library for arbitrary precision decimal floating point arithmetic."
  homepage "http://www.bytereef.org/mpdecimal/index.html"
  url "http://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.4.1.tar.gz"
  sha256 "da74d3cfab559971a4fbd4fb506e1b4498636eb77d0fd09e44f8e546d18ac068"

  # Patch the makefile to allow OS X to build the shared lib
  # The OS X ld needs -dynamiclib and -install_name to build a shared lib
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <mpdecimal.h>

      int main()
      {
        mpd_context_t ctx;
        mpd_t *a, *b, *result;
        mpd_defaultcontext(&ctx);

        result = mpd_new(&ctx);
        a = mpd_new(&ctx);
        b = mpd_new(&ctx);

        mpd_set_string(a, "0.1234", &ctx);
        mpd_set_string(b, "0.12340000", &ctx);

        mpd_compare(result, a, b, &ctx);
        int r = mpd_get_i32(result, &ctx);
        assert(r == 0);

        mpd_del(a);
        mpd_del(b);
        mpd_del(result);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmpdec", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/libmpdec/Makefile.in b/libmpdec/Makefile.in
index 9396f61..513668f 100644
--- a/libmpdec/Makefile.in
+++ b/libmpdec/Makefile.in
@@ -53,7 +53,11 @@ $(LIBSTATIC): Makefile $(OBJS)
 	$(RANLIB) $(LIBSTATIC)

 $(LIBSHARED): Makefile $(SHARED_OBJS)
+ifeq ($(shell uname), Darwin)
+	$(LD) $(MPD_LDFLAGS) -dynamiclib -Wl,-install_name,$(LIBSONAME) -o $(LIBSHARED) $(SHARED_OBJS) -lm
+else
 	$(LD) $(MPD_LDFLAGS) -shared -Wl,-soname,$(LIBSONAME) -o $(LIBSHARED) $(SHARED_OBJS) -lm
+endif
 	ln -sf $(LIBSHARED) libmpdec.so
 	ln -sf $(LIBSHARED) $(LIBSONAME)
