require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/josh/brew-pip'
  url 'https://github.com/josh/brew-pip/tarball/v0.1.2'
  md5 'de88d7e2c08dc85d9f71ae5a2f3fdece'

  def patches
    DATA
  end

  def install
    bin.install 'bin/brew-pip'
  end
end

__END__
diff --git a/bin/brew-pip b/bin/brew-pip
index 7f433c8..394904f 100755
--- a/bin/brew-pip
+++ b/bin/brew-pip
@@ -4,6 +4,8 @@ import os
 import sys
 import tempfile
 import xmlrpclib
+import httplib
+import urlparse
 import re
 
 argv = sys.argv
@@ -20,8 +22,47 @@ elif "--version" in argv:
     argv.remove("--version")
     verbose = True
 
-
-client = xmlrpclib.ServerProxy('http://pypi.python.org/pypi')
+class ProxiedTransport(xmlrpclib.Transport):
+    def __init__(self, proxy, *args, **kwargs):
+        xmlrpclib.Transport.__init__(self, *args, **kwargs)
+        self.proxy = proxy
+
+        if self._need_compat():
+            self.make_connection = self._compat_make_connection
+
+    def _need_compat(self):
+        try:
+            self._connection
+            return False
+        except AttributeError:
+            return True
+
+    def make_connection(self, host):
+        # works with >= 2.7
+        self.realhost = host
+        chost, self._extra_headers, x509 = self.get_host_info(self.proxy)
+        h = httplib.HTTPConnection(chost)
+        return h
+
+    def _compat_make_connection(self, host):
+        # works with <= 2.6
+        self.realhost = host
+        h = httplib.HTTP(self.proxy)
+        return h
+
+    def send_request(self, connection, handler, request_body):
+        connection.putrequest("POST", 'http://%s%s' % (self.realhost, handler))
+
+    def send_host(self, connection, host):
+        connection.putheader('Host', self.realhost)
+
+if os.getenv('http_proxy'):
+    p = ProxiedTransport(urlparse.urlparse(os.getenv('http_proxy')).netloc)
+    if verbose:
+        print "using proxy: %s" % p.__dict__['proxy']
+    client = xmlrpclib.ServerProxy('http://pypi.python.org/pypi', transport=p)
+else:
+    client = xmlrpclib.ServerProxy('http://pypi.python.org/pypi')
 
 releases = client.package_releases(argv[1])
