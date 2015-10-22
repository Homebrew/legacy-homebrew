class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.14.2-Source.tar.gz"
  sha256 "9323ca03d989ca4175b069f0752dd3cd0ff4a26a22e8837ca7647d2135775344"

  bottle do
    sha256 "7a0cf51c46783c775ba0ad7ee0d28a37aa61cf4fa405657072fe66af97301e87" => :el_capitan
    sha256 "1734c076ba6d2b4d078196d8fa04185181ce0a42424adcc2881c21c7bce73933" => :yosemite
    sha256 "0c0bff9379631e5b0d8d7da4a6e92cd8c7c051e215be01f13e203e136e197d89" => :mavericks
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
