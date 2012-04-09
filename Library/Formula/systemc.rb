require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Systemc < Formula
  homepage 'http://www.accellera.org/home/'
  url 'https://github.com/systemc/systemc-2.3.git'

  def patches
    DATA
  end

  fails_with :clang do
    build 318
  end

  def install
    mkdir "objdir" do
      system "../configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
      system "make install"
    end
  end

  def test
    system "make check"
  end
end

__END__
diff -Naur old/configure new/configure
--- old/configure   2012-04-01 18:27:27.000000000 -0400
+++ new/configure       2012-04-01 18:28:24.000000000 -0400
@@ -4987,7 +4987,7 @@
                 TARGET_ARCH="macosx386"
                #CCAS=as
                 ;;
-            c++ | g++)
+            c++ | g++ | llvm-g++)
                 TARGET_ARCH="macosx386"
                 ;;
             *)
@@ -5005,7 +5005,7 @@
                 TARGET_ARCH="macosx"
                CCAS=as
                 ;;
-            c++ | g++)
+            c++ | g++ | llvm-g++)
                 TARGET_ARCH="macosx"
                 ;;
             *)
@@ -5023,7 +5023,7 @@
                 TARGET_ARCH="sparcOS5"
                CCAS=as
                 ;;
-            c++ | g++)
+            c++ | g++ | llvm-g++)
                 TARGET_ARCH="gccsparcOS5"
                 ;;
             *)
