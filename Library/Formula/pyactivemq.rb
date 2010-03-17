require 'formula'

class Pyactivemq <Formula
  url 'http://pyactivemq.googlecode.com/files/pyactivemq-0.1.0.tar.gz'
  homepage 'http://pyactivemq.googlecode.com/'
  md5 '2ba32ab034c91a6fc6d0deb581d6ea27'
  depends_on 'activemq-cpp'
  
  def patches; DATA end
   
  def install
    ENV.gcc_4_2
    ENV.no_optimization
    system "python setup.py build"    
    system "python setup.py install --prefix=#{prefix}"
    ln_s "#{lib}/python2.6/site-packages/pyactivemq.so", "/Library/Python/2.6/site-packages/pyactivemq.so"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 8cd01ce..ebff85d 100644
--- a/setup.py
+++ b/setup.py
@@ -14,77 +14,36 @@
 
 from distutils.core import setup
 from distutils.extension import Extension
-from distutils.util import get_platform
 import os.path
-import sys
 
-if get_platform().startswith('win'):
-    include_dirs = [
-        '..\\activemq-cpp\\src\\main'
-        ]
-    if get_platform() == 'win-amd64':
-        include_dirs += [
-            'C:\\Program Files\\boost\\boost_1_36_0',
-            ]
-    else:
-        include_dirs += [
-            'C:\\Program Files (x86)\\boost\\boost_1_36_0',
-            ]
-    libraries = [
-        'libactivemq-cpp',
-        'apr-1',
-        'aprutil-1',
-        'apriconv-1',
-        'uuid',
-        'ws2_32',
-        'rpcrt4',
-        'mswsock',
-        'advapi32',
-        'shell32'
-        ]
-    if get_platform() == 'win-amd64':
-        library_dirs = [
-            'win_build\\Release.x64',
-            '..\\apr\\x64\\LibR',
-            '..\\apr-util\\x64\\LibR',
-            '..\\apr-iconv\\x64\\LibR',
-            'C:\\Program Files\\boost\\boost_1_36_0\\lib'
-            ]
-    else:
-        library_dirs = [
-            'win_build\\Release.Win32',
-            '..\\apr\\LibR',
-            '..\\apr-util\\LibR',
-            '..\\apr-iconv\\LibR',
-            'C:\\Program Files (x86)\\boost\\boost_1_36_0\\lib'
-            ]
-    extra_compile_args = ['/EHsc', '/GR', '/wd4290']
-    extra_link_args = ['/LTCG']
-    define_macros = [
-        ('BOOST_PYTHON_STATIC_LIB', 1),
-        ('BOOST_PYTHON_NO_PY_SIGNATURES', 1),
-        ('PYACTIVEMQ_ENABLE_DOCSTRINGS', 0)
-        ]
-else:
-    include_dirs = [
-        '/opt/activemq-cpp-2.2.1/include/activemq-cpp-2.2.1'
-        ]
-    libraries = [
-        'activemq-cpp',
-        'uuid',
-        'boost_python'
-        ]
-    library_dirs = [
-        '/opt/activemq-cpp-2.2.1/lib'
-        ]
-    extra_compile_args = []
-    extra_link_args = [
-        '-Wl,-rpath,/opt/activemq-cpp-2.2.1/lib'
-        ]
-    define_macros = [
-        ('BOOST_PYTHON_NO_PY_SIGNATURES', 1),
-        ('PYACTIVEMQ_ENABLE_DOCSTRINGS', 0)
-        ]
+include_dirs = [
+    '/usr/local/Cellar/boost/1.42.0/include',
+    '/usr/local/Cellar/activemq-cpp/2.2.6/include',
+    '/usr/local/Cellar/activemq-cpp/2.2.6/include/activemq-cpp-2.2.6',
+]
+
+libraries = [
+    'activemq-cpp',
+    'boost_python-mt'
+]
+
+library_dirs = [
+    '/usr/local/Cellar/activemq-cpp/2.2.6',
+    '/usr/local/Cellar/activemq-cpp/2.2.6/lib',
+    '/usr/local/Cellar/boost/1.42.0/',
+    '/usr/local/Cellar/boost/1.42.0/lib/',
+]
+
+extra_compile_args = []
+
+extra_link_args = [
+    '-Wl,-rpath,/usr/local/Cellar/activemq-cpp/2.2.6/lib'
+]
+
+define_macros = [
+    ('BOOST_PYTHON_NO_PY_SIGNATURES', 1),
+    ('PYACTIVEMQ_ENABLE_DOCSTRINGS', 0)
+]
 
 import glob
 files = glob.glob(os.path.join('src', 'main', '*.cpp'))