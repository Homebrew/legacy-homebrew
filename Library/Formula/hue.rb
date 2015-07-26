class Hue < Formula
  desc "Hue is a Web interface for analyzing data with Apache Hadoop."
  homepage "http://gethue.com/"
  url "https://github.com/cloudera/hue/archive/release-3.8.1.tar.gz"
  sha256 "582777f567b9f4a34e4ce58cfd5ed24aff15f3e02f193e7990329d8cb0161a8a"

  depends_on :java
  depends_on :mysql

  depends_on "gmp"
  depends_on "maven" => :build
  depends_on "openssl"

  # Patches have been merged upstream.  Should try building next release
  # (> 3.8.1) without them.
  #
  # Syntax error in 'parquet-python' library: 
  #   https://github.com/cloudera/hue/pull/206
  #
  # Fix to allow 'pyopenssl' == 0.13 to build w/ OpenSSL >= 1.0.2a:
  #   https://github.com/cloudera/hue/pull/207
  #
  patch :DATA

  def install
    ENV.append_to_cflags "-I" + `xcrun --show-sdk-path`.strip + "/usr/include/sasl" if MacOS.version >= :mavericks
    ENV.deparallelize

    system "make", "install", "PREFIX=#{libexec}", "SKIP_PYTHONDEV_CHECK=1"

    (libexec/"hue/desktop/conf").install "desktop/conf.dist/hue.ini"
    etc.install_symlink "#{libexec}/hue/desktop/conf/hue.ini"

    bin.install_symlink "#{libexec}/hue/build/env/bin/hue"
  end

  test do
    fork do
      system "#{bin}/hue", "runserver"
    end
    sleep(6)

    begin
      system "curl", "-s", "-S", "-f", "-L", "http://localhost:8000"
      assert_equal 0, $?.exitstatus
    ensure
      sleep(2)
      system "pkill", "-f", "hue"
    end
  end
end
__END__
diff --git a/desktop/core/ext-py/parquet-python/parquet/bitstring.py b/desktop/core/ext-py/parquet-python/parquet/bitstring.py
index ab807a2..7203c94 100644
--- a/desktop/core/ext-py/parquet-python/parquet/bitstring.py
+++ b/desktop/core/ext-py/parquet-python/parquet/bitstring.py
@@ -1,7 +1,5 @@
-
 SINGLE_BIT_MASK =  [1 << x for x in range(7, -1, -1)]
 
-]
 
 class BitString(object):
 
@@ -10,7 +8,6 @@ class BitString(object):
 		self.offset = offset if offset is not None else 0
 		self.length = length if length is not None else 8 * len(data) - self.offset 
 
-
 	def __getitem__(self, key):
 		try:
 			start = key.start
@@ -18,5 +15,5 @@ class BitString(object):
 		except AttributeError:
 			if key < 0 or key >= length:
 				raise IndexError()
-			byte_index, bit_offset = divmod(self.offset + key), 8)
-			return self.bytes[byte_index] & SINGLE_BIT_MASK[bit_offset]
\ No newline at end of file
+			byte_index, bit_offset = (divmod(self.offset + key), 8)
+			return self.bytes[byte_index] & SINGLE_BIT_MASK[bit_offset]
diff --git a/desktop/core/ext-py/pyopenssl/OpenSSL/crypto/crl.c b/desktop/core/ext-py/pyopenssl/OpenSSL/crypto/crl.c
index eec5bcb..b2fd681 100644
--- a/desktop/core/ext-py/pyopenssl/OpenSSL/crypto/crl.c
+++ b/desktop/core/ext-py/pyopenssl/OpenSSL/crypto/crl.c
@@ -3,7 +3,7 @@
 #include "crypto.h"
 
 
-static X509_REVOKED * X509_REVOKED_dup(X509_REVOKED *orig) {
+X509_REVOKED * X509_REVOKED_dup(X509_REVOKED *orig) {
     X509_REVOKED *dupe = NULL;
 
     dupe = X509_REVOKED_new();
