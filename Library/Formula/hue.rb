class Hue < Formula
  desc "Hue is a Web interface for analyzing data with Apache Hadoop."
  homepage "http://gethue.com/"
  url "https://github.com/cloudera/hue/archive/release-3.8.1.tar.gz"
  # version "3.8.1" # redundant with version scanned from URL
  sha256 "582777f567b9f4a34e4ce58cfd5ed24aff15f3e02f193e7990329d8cb0161a8a"

  # system dependencies - either Homebrew or Mac OS versions
  depends_on :java
  depends_on :python
  depends_on :mysql

  depends_on "maven" => :build
  depends_on "openssl" => :optional
  depends_on "gmp"

  patch :DATA

  def install
    # patched the Makefile vars to install to ${PREFIX}/libexec
    ohai "Building Hue from source - this process will take several minutes ..."
    system "make", "-j", "1", "install", "PREFIX=#{prefix}"

    ohai "Setting up the default configuration file"
    cp "desktop/conf.dist/hue.ini" "#{libexec}/desktop/conf/hue.ini"

    bin.install_symlink "#{libexec}/build/env/bin/hue"
    etc.install_symlink "#{libexec}/desktop/conf/hue.ini"
  end

  test do

    ohai "starting the Hue server in local mode"
    pid = fork do
      exec "#{bin}/hue", "runserver"
    end
    sleep(6)

    begin
      ohai "checking to make sure the server is running"
      system "curl -s -S -f -L http://localhost:8000"
      assert_equal 0, $?.exitstatus
    ensure
      sleep(2)
      ohai "stopping the Hue server"
      system "pkill -f hue"
    end
  end

end
__END__
diff --git a/desktop/core/ext-py/tablib-develop/setup.py b/desktop/core/ext-py/tablib-develop/setup.py
index fb16546..6f3bcfe 100755
--- a/desktop/core/ext-py/tablib-develop/setup.py
+++ b/desktop/core/ext-py/tablib-develop/setup.py
@@ -36,36 +36,46 @@ if sys.argv[-1] == 'test':
     os.system('py.test test_tablib.py')
     sys.exit()
 
-setup(
-    name='tablib',
-    version=tablib.__version__,
-    description='Format agnostic tabular data library (XLS, JSON, YAML, CSV)',
-    long_description=(open('README.rst').read() + '\n\n' +
-        open('HISTORY.rst').read()),
-    author='Kenneth Reitz',
-    author_email='me@kennethreitz.com',
-    url='http://python-tablib.org',
-    packages=[
-        'tablib', 'tablib.formats',
-        'tablib.packages',
+packages = [
+    'tablib', 'tablib.formats',
+    'tablib.packages',
+    'tablib.packages.omnijson',
+    'tablib.packages.unicodecsv'
+]
+
+if sys.version_info[0] == 2:
+    packages.extend([
         'tablib.packages.xlwt',
-        'tablib.packages.xlwt3',
         'tablib.packages.xlrd',
-        'tablib.packages.xlrd3',
-        'tablib.packages.omnijson',
         'tablib.packages.odf',
-        'tablib.packages.odf3',
         'tablib.packages.openpyxl',
         'tablib.packages.openpyxl.shared',
         'tablib.packages.openpyxl.reader',
         'tablib.packages.openpyxl.writer',
+        'tablib.packages.yaml'
+    ])
+else:
+    packages.extend([
+        'tablib.packages.xlwt3',
+        'tablib.packages.xlrd3',
+        'tablib.packages.odf3',
         'tablib.packages.openpyxl3',
         'tablib.packages.openpyxl3.shared',
         'tablib.packages.openpyxl3.reader',
         'tablib.packages.openpyxl3.writer',
-        'tablib.packages.yaml',
-        'tablib.packages.unicodecsv'
-    ],
+        'tablib.packages.yaml3'
+    ])
+
+setup(
+    name='tablib',
+    version=tablib.__version__,
+    description='Format agnostic tabular data library (XLS, JSON, YAML, CSV)',
+    long_description=(open('README.rst').read() + '\n\n' +
+        open('HISTORY.rst').read()),
+    author='Kenneth Reitz',
+    author_email='me@kennethreitz.com',
+    url='http://python-tablib.org',
+    packages=packages,
     license='MIT',
     classifiers=(
         'Development Status :: 5 - Production/Stable',

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
diff --git a/Makefile.vars.priv b/Makefile.vars.priv
index 79bc443..e17e192 100644
--- a/Makefile.vars.priv
+++ b/Makefile.vars.priv
@@ -53,7 +53,7 @@ BLD_DIR_DOC := $(BLD_DIR)/docs
 
 # Installation directory
 PREFIX ?= /usr/local
-INSTALL_DIR ?= $(PREFIX)/hue
+INSTALL_DIR ?= $(PREFIX)/libexec
 INSTALL_APPS_DIR ?= $(INSTALL_DIR)/desktop/apps
 
 ifeq ($(INSTALL_DIR),$(patsubst /%,%,$(INSTALL_DIR)))
