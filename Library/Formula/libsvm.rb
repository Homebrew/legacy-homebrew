require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.11.tar.gz'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  md5 '44d2a3a611280ecd0d66aafe0d52233e'

  def patches
    # Patches Makefile for Python egg creation
    DATA
  end

  def install
    inreplace 'Makefile', '-soname', '-install_name'
    inreplace 'Makefile', 'libsvm.so.$(SHVER)', 'libsvm.$(SHVER).dylib'

    system "make"
    system "make lib"
    ln_s 'libsvm.2.dylib', 'libsvm.dylib'

    # Install C interface and binaries
    bin.install ['svm-scale', 'svm-train', 'svm-predict']
    lib.install ['libsvm.2.dylib', 'libsvm.dylib']
    include.install ['svm.h']

    # Copy Python egg archive
    prefix.install ['python/package/dist/LibSVM-3.11.tar.gz']
  end

  def caveats
    general_caveats = <<-EOF.undent
      LibSVM has been installed!
      If you need the Python module, you can run :

        sudo easy_install "#{prefix}/LibSVM-3.11.tar.gz"

      This will hatch a Python egg in the system's default location.
    EOF
  end
end

__END__
--- a/Makefile	2012-02-11 20:14:54.000000000 +0100
+++ b/Makefile	2012-02-11 21:14:54.000000000 +0100
@@ -2,7 +2,7 @@
 CFLAGS = -Wall -Wconversion -O3 -fPIC
 SHVER = 2
 
-all: svm-train svm-predict svm-scale
+all: svm-train svm-predict svm-scale egg
 
 lib: svm.o
 	$(CXX) -shared -dynamiclib -Wl,-install_name,libsvm.so.$(SHVER) svm.o -o libsvm.so.$(SHVER)
@@ -17,3 +17,23 @@
 	$(CXX) $(CFLAGS) -c svm.cpp
 clean:
 	rm -f *~ svm.o svm-train svm-predict svm-scale libsvm.so.$(SHVER)
+
+define _LIBSVM_SETUP_EGG
+#!/usr/bin/env python
+# coding=utf-8
+
+from setuptools import setup, find_packages
+setup(
+		name = "LibSVM",
+		version = "3.11",
+		packages = find_packages(),
+)
+endef
+export _LIBSVM_SETUP_EGG
+
+egg:
+	mkdir -p python/package/libsvm/
+	touch python/package/libsvm/__init__.py
+	cp python/svm.py python/svmutil.py python/package/libsvm/
+	echo "$$_LIBSVM_SETUP_EGG" > python/package/setup.py
+	cd python/package/; python setup.py sdist
