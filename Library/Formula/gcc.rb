require "formula"

class Gcc < Formula
  def arch
    if Hardware::CPU.type == :intel
      if MacOS.prefer_64_bit?
        "x86_64"
      else
        "i686"
      end
    elsif Hardware::CPU.type == :ppc
      if MacOS.prefer_64_bit?
        "powerpc64"
      else
        "powerpc"
      end
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  homepage "http://gcc.gnu.org"
  url "http://ftpmirror.gnu.org/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  sha1 "3f303f403053f0ce79530dae832811ecef91197e"
  revision 1

  bottle do
    revision 2
    sha1 "4a7fc491b6487da16089c218f9dda8d23e8656b5" => :mavericks
    sha1 "9e826e179f7f679d1423b8d92d9a647860bd27ae" => :mountain_lion
    sha1 "81d02ad2e353ed804927ee166a1090ebf057c4b3" => :lion
  end

  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "without-fortran", "Build without the gfortran compiler"
  # enabling multilib on a host that can't run 64-bit results in build failures
  option "without-multilib", "Build without multilib support" if MacOS.prefer_64_bit?

  # Fix Makefile bug concerning MacOSX >= 10.10
  # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61407
  if build.stable? and MacOS.version >= :yosemite
     patch :DATA
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "cloog"
  depends_on "isl"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  if MacOS.version < :leopard
    # The as that comes with Tiger isn't capable of dealing with the
    # PPC asm that comes in libitm
    depends_on "cctools" => :build
  end

  fails_with :gcc_4_0

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  def version_suffix
    version.to_s.slice(/\d\.\d/)
  end

  # Fix 10.10 issues: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61407
  patch do
    url "https://gcc.gnu.org/bugzilla/attachment.cgi?id=33180"
    sha1 "def0cb036a255175db86f106e2bb9dd66d19b702"
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    if MacOS.version < :leopard
      ENV["AS"] = ENV["AS_FOR_TARGET"] = "#{Formula["cctools"].bin}/as"
    end

    # C, C++, ObjC compilers are always built
    languages = %w[c c++ objc obj-c++]

    # Everything but Ada, which requires a pre-existing GCC Ada compiler
    # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
    # currently only compilable on Linux.
    languages << "fortran" if build.with?("fortran") || build.with?("all-languages")
    languages << "java" if build.with?("java") || build.with?("all-languages")

    args = [
      "--build=#{arch}-apple-darwin#{osmajor}",
      "--prefix=#{prefix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-cloog=#{Formula["cloog"].opt_prefix}",
      "--with-isl=#{Formula["isl"].opt_prefix}",
      "--with-system-zlib",
      # This ensures lib, libexec, include are sandboxed so that they
      # don't wander around telling little children there is no Santa
      # Claus.
      "--enable-version-specific-runtime-libs",
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew #{name} #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew/issues",
    ]

    # "Building GCC with plugin support requires a host that supports
    # -fPIC, -shared, -ldl and -rdynamic."
    args << "--enable-plugin" if MacOS.version > :tiger

    # Otherwise make fails during comparison at stage 3
    # See: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=45248
    args << "--with-dwarf2" if MacOS.version < :leopard

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_prefix}/share/java/ecj.jar"
    end

    if build.without?("multilib") || !MacOS.prefer_64_bit?
      args << "--disable-multilib"
    else
      args << "--enable-multilib"
    end

    mkdir "build" do
      unless MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-header's will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      system "../configure", *args
      system "make", "bootstrap"
      system "make", "install"

      if build.with?("fortran") || build.with?("all-languages")
        bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Since GCC 4.8 libffi stuff are no longer shipped.
    # Rename libiberty.a.
    Dir.glob(prefix/"**/libiberty.*") { |file| add_suffix file, version_suffix }
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when suffixes are appended, the info pages conflict when
    # install-info is run. TODO fix this.
    info.rmtree

    # Rename java properties
    if build.with?("java") || build.with?("all-languages")
      config_files = [
        "#{lib}/logging.properties",
        "#{lib}/security/classpath.security",
        "#{lib}/i386/logging.properties",
        "#{lib}/i386/security/classpath.security"
      ]
      config_files.each do |file|
        add_suffix file, version_suffix if File.exist? file
      end
    end
  end

  def add_suffix file, suffix
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def caveats
    if build.with?("multilib") then <<-EOS.undent
      GCC has been built with multilib support. Notably, OpenMP may not work:
        https://gcc.gnu.org/bugzilla/show_bug.cgi?id=60670
      If you need OpenMP support you may want to
        brew reinstall gcc --without-multilib
      EOS
    end
  end

  test do
    if build.with?("fortran") || build.with?("all-languages")
      fixture = <<-EOS.undent
        integer,parameter::m=10000
        real::a(m), b(m)
        real::fact=0.5

        do concurrent (i=1:m)
          a(i) = a(i) + fact*b(i)
        end do
        print *, "done"
        end
      EOS
      (testpath/"in.f90").write(fixture)
      system "#{bin}/gfortran", "-c", "in.f90"
      system "#{bin}/gfortran", "-o", "test", "in.o"
      assert_equal "done", `./test`.strip
    end
  end
end

__END__
diff --git a/fixincludes/fixincl.x b/fixincludes/fixincl.x
index 10b4061..8b47381 100644
--- a/fixincludes/fixincl.x
+++ b/fixincludes/fixincl.x
@@ -15,7 +15,7 @@
  * certain ANSI-incompatible system header files which are fixed to work
  * correctly with ANSI C and placed in a directory that GNU C will search.
  *
- * This file contains 229 fixup descriptions.
+ * This file contains 230 fixup descriptions.
  *
  * See README for more information.
  *
@@ -101,6 +101,45 @@ extern off64_t ftello(FILE *) __asm__(\"ftello64\");\n\
 
 /* * * * * * * * * * * * * * * * * * * * * * * * * *
  *
+ *  Description of Darwin14_Has_Feature fix
+ */
+tSCC zDarwin14_Has_FeatureName[] =
+     "darwin14_has_feature";
+
+/*
+ *  File name selection pattern
+ */
+tSCC zDarwin14_Has_FeatureList[] =
+  "Availability.h\0";
+/*
+ *  Machine/OS name selection pattern
+ */
+tSCC* apzDarwin14_Has_FeatureMachs[] = {
+        "*-*-darwin14.0*",
+        (const char*)NULL };
+#define DARWIN14_HAS_FEATURE_TEST_CT  0
+#define aDarwin14_Has_FeatureTests   (tTestDesc*)NULL
+
+/*
+ *  Fix Command Arguments for Darwin14_Has_Feature
+ */
+static const char* apzDarwin14_Has_FeaturePatch[] = {
+    "wrap",
+    "\n\
+/* GCC doesn't support __has_feature built-in in C mode and\n\
+ * using defined(__has_feature) && __has_feature in the same\n\
+ * macro expression is not valid. So, easiest way is to define\n\
+ * for this header __has_feature as a macro, returning 0, in case\n\
+ * it is not defined internally\n\
+ */\n\
+#ifndef __has_feature\n\
+#define __has_feature(x) 0\n\
+#endif\n",
+    (char*)NULL };
+
+
+/* * * * * * * * * * * * * * * * * * * * * * * * * *
+ *
  *  Description of Aab_Aix_Fcntl fix
  */
 tSCC zAab_Aix_FcntlName[] =
@@ -9405,7 +9444,7 @@ static const char* apzX11_SprintfPatch[] = {
  */
 #define REGEX_COUNT          268
 #define MACH_LIST_SIZE_LIMIT 187
-#define FIX_COUNT            229
+#define FIX_COUNT            230
 
 /*
  *  Enumerate the fixes
@@ -9639,7 +9678,8 @@ typedef enum {
     X11_CLASS_FIXIDX,
     X11_CLASS_USAGE_FIXIDX,
     X11_NEW_FIXIDX,
-    X11_SPRINTF_FIXIDX
+    X11_SPRINTF_FIXIDX,
+    DARWIN14_HAS_FEATURE_FIXIDX
 } t_fixinc_idx;
 
 tFixDesc fixDescList[ FIX_COUNT ] = {
@@ -10786,5 +10826,10 @@ tFixDesc fixDescList[ FIX_COUNT ] = {
   {  zX11_SprintfName,    zX11_SprintfList,
      apzX11_SprintfMachs,
      X11_SPRINTF_TEST_CT, FD_MACH_ONLY | FD_SUBROUTINE,
-     aX11_SprintfTests,   apzX11_SprintfPatch, 0 }
+     aX11_SprintfTests,   apzX11_SprintfPatch, 0 },
+
+  {  zDarwin14_Has_FeatureName,    zDarwin14_Has_FeatureList,
+     apzDarwin14_Has_FeatureMachs,
+     DARWIN14_HAS_FEATURE_TEST_CT, FD_MACH_ONLY | FD_SUBROUTINE,
+     aDarwin14_Has_FeatureTests,   apzDarwin14_Has_FeaturePatch, 0 }
 };
diff --git a/fixincludes/inclhack.def b/fixincludes/inclhack.def
index 411300f..0f53a8e 100644
--- a/fixincludes/inclhack.def
+++ b/fixincludes/inclhack.def
@@ -4881,4 +4881,33 @@ fix = {
 
     test_text = "extern char *\tsprintf();";
 };
+
+/*
+ * Fix stdio.h using C++ __has_feature built-in on OS X 10.10
+ */
+fix = {
+    hackname  = darwin14_has_feature;
+    files     = Availability.h;
+    mach      = "*-*-darwin14.0*";
+    
+    c_fix     = wrap;
+    c_fix_arg = <<- _HasFeature_
+
+/*
+ * GCC doesn't support __has_feature built-in in C mode and
+ * using defined(__has_feature) && __has_feature in the same
+ * macro expression is not valid. So, easiest way is to define
+ * for this header __has_feature as a macro, returning 0, in case
+ * it is not defined internally
+ */
+#ifndef __has_feature
+#define __has_feature(x) 0
+#endif
+
+
+_HasFeature_;
+    
+    test_text = '';
+};
+
 /*EOF*/
diff --git a/gcc/config/darwin-c.c b/gcc/config/darwin-c.c
index 892ba35..39f795f 100644
--- a/gcc/config/darwin-c.c
+++ b/gcc/config/darwin-c.c
@@ -572,20 +572,31 @@ find_subframework_header (cpp_reader *pfile, const char *header, cpp_dir **dirp)
 
 /* Return the value of darwin_macosx_version_min suitable for the
    __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ macro,
-   so '10.4.2' becomes 1040.  The lowest digit is always zero.
-   Print a warning if the version number can't be understood.  */
+   so '10.4.2' becomes 1040 and '10.10.0' becomes 101000.  The lowest
+   digit is always zero. Print a warning if the version number
+   can't be understood.  */
 static const char *
 version_as_macro (void)
 {
-  static char result[] = "1000";
+  static char result[7] = "1000";
+  int minorDigitIdx;
 
   if (strncmp (darwin_macosx_version_min, "10.", 3) != 0)
     goto fail;
   if (! ISDIGIT (darwin_macosx_version_min[3]))
     goto fail;
-  result[2] = darwin_macosx_version_min[3];
-  if (darwin_macosx_version_min[4] != '\0'
-      && darwin_macosx_version_min[4] != '.')
+
+  minorDigitIdx = 3;
+  result[2] = darwin_macosx_version_min[minorDigitIdx++];
+  if (ISDIGIT(darwin_macosx_version_min[minorDigitIdx])) {
+    /* Starting with 10.10 numeration for mactro changed */
+    result[3] = darwin_macosx_version_min[minorDigitIdx++];
+    result[4] = '0';
+    result[5] = '0';
+    result[6] = '\0';
+  }
+  if (darwin_macosx_version_min[minorDigitIdx] != '\0'
+      && darwin_macosx_version_min[minorDigitIdx] != '.')
     goto fail;
 
   return result;
diff --git a/gcc/config/darwin-driver.c b/gcc/config/darwin-driver.c
index 8b6ae93..a115616 100644
--- a/gcc/config/darwin-driver.c
+++ b/gcc/config/darwin-driver.c
@@ -57,7 +57,7 @@ darwin_find_version_from_kernel (char *new_flag)
   version_p = osversion + 1;
   if (ISDIGIT (*version_p))
     major_vers = major_vers * 10 + (*version_p++ - '0');
-  if (major_vers > 4 + 9)
+  if (major_vers > 4 + 10)
     goto parse_failed;
   if (*version_p++ != '.')
     goto parse_failed;
diff --git a/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc b/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
index 196eb3b..aae2a13 100644
--- a/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
+++ b/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
@@ -835,8 +835,10 @@ CHECK_SIZE_AND_OFFSET(cmsghdr, cmsg_type);
 
 COMPILER_CHECK(sizeof(__sanitizer_dirent) <= sizeof(dirent));
 CHECK_SIZE_AND_OFFSET(dirent, d_ino);
-#if SANITIZER_MAC
+#if SANITIZER_MAC && ( !defined(__DARWIN_64_BIT_INO_T) || __DARWIN_64_BIT_INO_T)
 CHECK_SIZE_AND_OFFSET(dirent, d_seekoff);
+#elif SANITIZER_MAC
+// There is no d_seekoff with non 64-bit ino_t
 #else
 CHECK_SIZE_AND_OFFSET(dirent, d_off);
 #endif
diff --git a/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.h b/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.h
index be6e6cf..c99c64f 100644
--- a/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.h
+++ b/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.h
@@ -275,12 +275,20 @@ namespace __sanitizer {
 #endif
 
 #if SANITIZER_MAC
+# if ! defined(__DARWIN_64_BIT_INO_T) || __DARWIN_64_BIT_INO_T
   struct __sanitizer_dirent {
     unsigned long long d_ino;
     unsigned long long d_seekoff;
     unsigned short d_reclen;
     // more fields that we don't care about
   };
+# else
+  struct __sanitizer_dirent {
+    unsigned int d_ino;
+    unsigned short d_reclen;
+    // more fields that we don't care about
+  };
+# endif
 #elif SANITIZER_ANDROID || defined(__x86_64__)
   struct __sanitizer_dirent {
     unsigned long long d_ino;
