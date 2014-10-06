require 'formula'

class GribApi < Formula
  homepage 'https://software.ecmwf.int/wiki/display/GRIB/Home'
  url 'https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.12.3.tar.gz'
  sha1 '2764b262c8f081fefb81112f7f7463a3a34b6e66'

  bottle do
    sha1 "aaa46754fcaa6f19099a2045000ba8ee4e93f29e" => :mavericks
    sha1 "92d2fae3c922dcb1aef946b03b6afc858c9403c1" => :mountain_lion
    sha1 "6b4ffc9b85b1ba3581dcc9cfe4d4aa292542abf9" => :lion
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
