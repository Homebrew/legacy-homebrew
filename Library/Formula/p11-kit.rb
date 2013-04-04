require 'formula'

class P11Kit < Formula
  homepage 'http://p11-glue.freedesktop.org'
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.18.0.tar.gz'
  sha256 '9ebcdcf57b7686b92146cf475cb2b66cdf3757f6e62d8e77c39dae89ffb43e31'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'

  def patches; DATA end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-trust-paths"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
diff --git a/p11-kit/tests/test-init.c b/p11-kit/tests/test-init.c
index 7df4be9..557d0c2 100644
--- a/p11-kit/tests/test-init.c
+++ b/p11-kit/tests/test-init.c
@@ -274,7 +274,7 @@ test_load_and_initialize (CuTest *tc)
 	CK_RV rv;
 	int ret;
 
-	rv = p11_kit_load_initialize_module (BUILDDIR "/.libs/mock-one" SHLEXT, &module);
+	rv = p11_kit_load_initialize_module (BUILDDIR "/.libs/mock-one.so", &module);
 	CuAssertTrue (tc, rv == CKR_OK);
 	CuAssertTrue (tc, module != NULL);
 
