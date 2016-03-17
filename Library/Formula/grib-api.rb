class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.14.7-Source.tar.gz"
  sha256 "a42b9b0bd6bd2364897c13feafd09adba6a52e05866db61d2d7ab5ee0534f1f7"

  bottle do
    sha256 "225eccf4e850b18d3b46ac35d55618f0348256794473795ee0ca8a7fbc319ec2" => :el_capitan
    sha256 "87a9bbc980bdd0e7b4aded23fe8e1063004f26141d1efc4a3b49ab2700c4a353" => :yosemite
    sha256 "6a10d0d9a39fda3c06505fd0b8a3f2fded6652bb2ac4e11a80d2cbcd5eb5441c" => :mavericks
  end

  depends_on :fortran
  depends_on "cmake" => :build
  depends_on "jasper" => :recommended
  depends_on "openjpeg" => :optional

  # Fixes build errors in Lion
  # https://software.ecmwf.int/wiki/plugins/viewsource/viewpagesrc.action?pageId=12648475
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system "#{bin}/grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system "#{bin}/grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
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
