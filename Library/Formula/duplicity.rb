require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.22/+download/duplicity-0.6.22.tar.gz'
  sha1 'afa144f444148b67d7649b32b80170d917743783'

  depends_on 'librsync'
  depends_on 'gnupg'

  option :universal

  def replace_patch_tokens(io)
    patch = io.read
    patch.gsub!("DUPLICITY_SITE_PACKAGES", lib/"python2.7/site-packages")
    StringIO.new(patch)
  end

  def patches
    # Fix sys.path misbehavings
    replace_patch_tokens(DATA)
  end

  def install
    ENV.universal_binary if build.universal?
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end

__END__
--- a/bin/duplicity	2013-11-07 16:34:44.000000000 +0100
+++ b/bin/duplicity	2013-11-07 16:48:53.000000000 +0100
@@ -32,9 +32,7 @@
 import threading
 from datetime import datetime
 
-pwd = os.path.abspath(os.path.dirname(sys.argv[0]))
-if os.path.exists(os.path.join(pwd, "../duplicity")):
-    sys.path.insert(0, os.path.abspath(os.path.join(pwd, "../.")))
+sys.path.insert(0, 'DUPLICITY_SITE_PACKAGES')
 
 import gettext
 gettext.install('duplicity', codeset='utf8')
--- a/bin/rdiffdir	2013-11-07 16:55:22.000000000 +0100
+++ b/bin/rdiffdir	2013-11-07 16:56:46.000000000 +0100
@@ -27,6 +27,8 @@
 
 import sys, getopt, gzip, os
 
+sys.path.insert(0, 'DUPLICITY_SITE_PACKAGES')
+
 import gettext
 gettext.install('duplicity', codeset='utf8')
 
