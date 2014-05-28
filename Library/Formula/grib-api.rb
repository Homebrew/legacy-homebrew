require 'formula'

class GribApi < Formula
  homepage 'https://software.ecmwf.int/wiki/display/GRIB/Home'
  url 'https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.12.0.tar.gz'
  sha1 '93ab1d38721c3f00e3d3753a32a8cd8b1bf674ef'

  depends_on :fortran
  depends_on 'jasper' => :recommended
  depends_on 'openjpeg' => :optional
  depends_on 'python' => :optional

  # Fixes build errors
  # https://software.ecmwf.int/wiki/plugins/viewsource/viewpagesrc.action?pageId=12648475
  patch :DATA

  # grib_api is not a Python package because it lacks __init__.py.
  # And common use even in the grib_api examples is to:
  #   import gribapi
  # rather than to:
  #   from grib_api import gribapi
  # We fix two birds with one stone by a gribapi.pth which points to grib_api.
  # https://software.ecmwf.int/issues/browse/SUP-409
  # (Issue resolved by upstream asking to fix it in your package managers.)
  def gribapi
    Pathname.new(IO.popen('find `python-config --prefix` -name "site-packages"').read.strip)/"gribapi.pth"
  end

  def install
    ENV.deparallelize
    ENV.no_optimization

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--enable-python" if build.with? "python"

    system "./configure", *args
    system "make"
    system "make install"

    gribapi.write <<-EOS.undent
      grib_api
    EOS

  end
end

__END__
diff --git a/configure b/configure
index 2cc490f..f9eafdd 100755
--- a/configure
+++ b/configure
@@ -7016,7 +7016,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic='-fno-common'
+      lt_prog_compiler_pic=''
       ;;
 
     hpux*)
@@ -12205,7 +12205,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_F77='-fno-common'
+      lt_prog_compiler_pic_F77=''
       ;;
 
     hpux*)
@@ -15233,7 +15233,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_FC='-fno-common'
+      lt_prog_compiler_pic_FC=''
       ;;
 
     hpux*)
diff --git a/m4/libtool.m4 b/m4/libtool.m4
index b1251be..07f80ff 100644
--- a/m4/libtool.m4
+++ b/m4/libtool.m4
@@ -3581,7 +3581,7 @@ m4_if([$1], [CXX], [
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      _LT_TAGVAR(lt_prog_compiler_pic, $1)='-fno-common'
+      _LT_TAGVAR(lt_prog_compiler_pic, $1)=''
       ;;
     *djgpp*)
       # DJGPP does not support shared libraries at all
@@ -3889,7 +3889,7 @@ m4_if([$1], [CXX], [
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      _LT_TAGVAR(lt_prog_compiler_pic, $1)='-fno-common'
+      _LT_TAGVAR(lt_prog_compiler_pic, $1)=''
       ;;
 
     hpux*)
