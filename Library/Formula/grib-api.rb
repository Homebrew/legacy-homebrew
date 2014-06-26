require 'formula'

class GribApi < Formula
  homepage 'https://software.ecmwf.int/wiki/display/GRIB/Home'
  url 'https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.12.1.tar.gz'
  sha1 'b769ac5db70703f0d944d93aafbbeee7513958f1'

  bottle do
    sha1 "700f762ea40861f34639f8abbd99807c43048b90" => :mavericks
    sha1 "649fc9c1630dd630a9442c20a47127627ae5f22c" => :mountain_lion
    sha1 "b395b0e5bf33981bdd2f9bef5ac777f2828680f7" => :lion
  end

  depends_on :fortran
  depends_on 'jasper' => :recommended
  depends_on 'openjpeg' => :optional

  # Fixes build errors in Lion
  # https://software.ecmwf.int/wiki/plugins/viewsource/viewpagesrc.action?pageId=12648475
  patch :DATA

  def install
    ENV.deparallelize
    ENV.no_optimization

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 0a88b28..9dafe46 100755
--- a/configure
+++ b/configure
@@ -7006,7 +7006,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic='-fno-common'
+      #lt_prog_compiler_pic='-fno-common'
       ;;
 
     hpux*)
@@ -12186,7 +12186,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_F77='-fno-common'
+      #lt_prog_compiler_pic_F77='-fno-common'
       ;;
 
     hpux*)
@@ -15214,7 +15214,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_FC='-fno-common'
+      #lt_prog_compiler_pic_FC='-fno-common'
       ;;
 
     hpux*)
