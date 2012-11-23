require 'formula'

class Z3 < Formula
  homepage 'http://z3.codeplex.com'
  url 'https://git01.codeplex.com/z3.git', :tag => 'v4.3.1'
  version '4.3.1'

  head 'https://git01.codeplex.com/z3.git'

  depends_on :autoconf => :build

  def patches
    DATA # Makefile tries to install files to /Library/Python/2.7/site-packages
  end

  def install
    system 'autoconf'
    ENV['CXX'] = 'g++' # Select g++ because it supports OpenMP whereas Clang does not.
    system './configure', "--prefix=#{prefix}"
    system 'python', 'scripts/mk_make.py'
    cd 'build' do
      system 'make'
      system 'make', 'install'
    end
  end
end

__END__
diff --git a/scripts/mk_util.py b/scripts/mk_util.py
index 54f1931..e7f8d00 100644
--- a/scripts/mk_util.py
+++ b/scripts/mk_util.py
@@ -17,7 +17,7 @@ from fnmatch import fnmatch
 import distutils.sysconfig
 import compileall
 
-PYTHON_PACKAGE_DIR=distutils.sysconfig.get_python_lib()
+PYTHON_PACKAGE_DIR=distutils.sysconfig.get_python_lib(True, False, '$(PREFIX)')
 BUILD_DIR='build'
 REV_BUILD_DIR='..'
 SRC_DIR='src'
@@ -811,6 +811,7 @@ def mk_install(out):
     out.write('\t@mkdir -p $(PREFIX)/bin\n')
     out.write('\t@mkdir -p $(PREFIX)/include\n')
     out.write('\t@mkdir -p $(PREFIX)/lib\n')
+    out.write('\t@mkdir -p %s\n' % PYTHON_PACKAGE_DIR)
     for c in get_components():
         c.mk_install(out)
     out.write('\t@cp z3*.pyc %s\n' % PYTHON_PACKAGE_DIR)
