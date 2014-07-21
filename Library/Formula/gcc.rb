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
  url "http://ftpmirror.gnu.org/gcc/gcc-4.8.3/gcc-4.8.3.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.3/gcc-4.8.3.tar.bz2"
  sha1 "da0a2b9ec074f2bf624a34f3507f812ebb6e4dce"
  revision 1

  head "svn://gcc.gnu.org/svn/gcc/branches/gcc-4_8-branch"

  bottle do
    sha1 "0e4040eb5a667ecacba2b7e7c71a7a868a593386" => :mavericks
    sha1 "78374c616c427d49e29656579d6a143cbb468b0b" => :mountain_lion
    sha1 "b3320839c172d7abc4f9889a67822e604e080a75" => :lion
  end

  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-profiled-build", "Make use of profile guided optimization when bootstrapping GCC"
  option "without-fortran", "Build without the gfortran compiler"
  # enabling multilib on a host that can't run 64-bit results in build failures
  option "without-multilib", "Build without multilib support" if MacOS.prefer_64_bit?

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
    # GCC 4.8.1 incorrectly determines that _Unwind_GetIPInfo is available on
    # Tiger, resulting in a failed build
    # Fixed upstream: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58710
    patch :DATA
  end

  fails_with :gcc_4_0

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
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

    version_suffix = version.to_s.slice(/\d\.\d/)

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

      if build.with? "profiled-build"
        # Takes longer to build, may bug out. Provided for those who want to
        # optimise all the way to 11.
        system "make", "profiledbootstrap"
      else
        system "make", "bootstrap"
      end

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

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
diff --git a/libbacktrace/backtrace.c b/libbacktrace/backtrace.c
index 428f53a..a165197 100644
--- a/libbacktrace/backtrace.c
+++ b/libbacktrace/backtrace.c
@@ -35,6 +35,14 @@ POSSIBILITY OF SUCH DAMAGE.  */
 #include "unwind.h"
 #include "backtrace.h"

+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 /* The main backtrace_full routine.  */

 /* Data passed through _Unwind_Backtrace.  */
diff --git a/libbacktrace/simple.c b/libbacktrace/simple.c
index b03f039..9f3a945 100644
--- a/libbacktrace/simple.c
+++ b/libbacktrace/simple.c
@@ -35,6 +35,14 @@ POSSIBILITY OF SUCH DAMAGE.  */
 #include "unwind.h"
 #include "backtrace.h"

+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 /* The simple_backtrace routine.  */

 /* Data passed through _Unwind_Backtrace.  */
diff --git a/libgcc/unwind-c.c b/libgcc/unwind-c.c
index b937d9d..1121dce 100644
--- a/libgcc/unwind-c.c
+++ b/libgcc/unwind-c.c
@@ -30,6 +30,14 @@ see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
 #define NO_SIZE_OF_ENCODED_VALUE
 #include "unwind-pe.h"

+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 typedef struct
 {
   _Unwind_Ptr Start;
diff --git a/libgfortran/runtime/backtrace.c b/libgfortran/runtime/backtrace.c
index 3b58118..9a00066 100644
--- a/libgfortran/runtime/backtrace.c
+++ b/libgfortran/runtime/backtrace.c
@@ -40,6 +40,14 @@ see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
 #include "unwind.h"


+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 /* Macros for common sets of capabilities: can we fork and exec, and
    can we use pipes to communicate with the subprocess.  */
 #define CAN_FORK (defined(HAVE_FORK) && defined(HAVE_EXECVE) \
diff --git a/libgo/runtime/go-unwind.c b/libgo/runtime/go-unwind.c
index c669a3c..9e848db 100644
--- a/libgo/runtime/go-unwind.c
+++ b/libgo/runtime/go-unwind.c
@@ -18,6 +18,14 @@
 #include "go-defer.h"
 #include "go-panic.h"

+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 /* The code for a Go exception.  */

 #ifdef __ARM_EABI_UNWINDER__
diff --git a/libobjc/exception.c b/libobjc/exception.c
index 4b05611..8ff70f9 100644
--- a/libobjc/exception.c
+++ b/libobjc/exception.c
@@ -31,6 +31,14 @@ see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
 #include "unwind-pe.h"
 #include <string.h> /* For memcpy */

+#ifdef __APPLE__
+/* On MacOS X, versions older than 10.5 don't export _Unwind_GetIPInfo.  */
+#undef HAVE_GETIPINFO
+#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= 1050
+#define HAVE_GETIPINFO 1
+#endif
+#endif
+
 /* 'is_kind_of_exception_matcher' is our default exception matcher -
    it determines if the object 'exception' is of class 'catch_class',
    or of a subclass.  */
