require 'formula'

# https version doesn't download with system curl on Snow Leopard
# https://github.com/mxcl/homebrew/issues/20339
class Cfengine < Formula
  homepage 'http://cfengine.com/'
  url 'http://cfengine.com/source-code/download?file=cfengine-3.5.2.tar.gz'
  sha1 '57ffeee2a2a6acb1764a8a0d7979538d683ccf5a'

  depends_on 'pcre'
  depends_on 'tokyo-cabinet'
  depends_on 'libxml2' if MacOS.version < :mountain_lion

  def patches
    # Fix compilation errors. Both changes are merged upstream already
    # https://github.com/cfengine/core/pull/947
    # https://github.com/cfengine/core/commit/d03fcc2d38a4db0c79386aaef30597102bf45853
    DATA
  end

  def install
    # Find our libpcre
    ENV.append 'LDFLAGS', "-L#{Formula.factory('pcre').opt_prefix}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-tokyocabinet"
    system "make install"
  end

  def test
    system "#{bin}/cf-agent", "-V"
  end
end

__END__
diff --git a/cf-agent/verify_environments.c b/cf-agent/verify_environments.c
index afb84ad..c59b599 100644
--- a/cf-agent/verify_environments.c
+++ b/cf-agent/verify_environments.c
@@ -282,13 +282,13 @@ static void VerifyEnvironments(EvalContext *ctx, Attributes a, Promise *pp)
     {
     case cfv_virt_vbox:
     case cfv_virt_test:
-        VerifyVirtDomain(hyper_uri, envtype, a, pp);
+        VerifyVirtDomain(ctx, hyper_uri, envtype, a, pp);
         break;
     case cfv_virt_xen_net:
     case cfv_virt_kvm_net:
     case cfv_virt_esx_net:
     case cfv_virt_test_net:
-        VerifyVirtNetwork(hyper_uri, envtype, a, pp);
+        VerifyVirtNetwork(ctx, hyper_uri, envtype, a, pp);
         break;
     default:
         break;
diff --git a/cf-agent/verify_files_utils.c b/cf-agent/verify_files_utils.c
index 21f195c..ec4ba0d 100644
--- a/cf-agent/verify_files_utils.c
+++ b/cf-agent/verify_files_utils.c
@@ -2271,7 +2271,6 @@ static void VerifyCopiedFileAttributes(EvalContext *ctx, const char *src, const
         if (!CopyFileExtendedAttributesDisk(src, dest))
         {
             cfPS(ctx, LOG_LEVEL_INFO, PROMISE_RESULT_FAIL, pp, attr, "Could not preserve extended attributes (ACLs and security contexts) on file '%s'", dest);
-            return NULL;
         }
     }
 }
