require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20130725oss_src.tgz'
  sha1 'f354bd9b67295f65c43531b751e34f483ed8a024'
  version '4.2'

  fails_with :llvm do
    cause 'llvm is not supported on macos. Add build/macos.llvm.inc file with compiler-specific settings.'
  end

  # tbb uses the wrong command (-v, verbose) to fetch the version from the
  # compiler, causing problems if the compiler returns additional debug info
  # Reported upstream at http://software.intel.com/en-us/forums/topic/475120
  def patches; DATA; end

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on, and use our compilers.
    args = ['tbb_build_prefix=BUILDPREFIX',
            "compiler=#{ENV.compiler}"]
    args << (MacOS.prefer_64_bit? ? "arch=intel64" : "arch=ia32")
    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end

__END__
diff --git a/build/version_info_macos.sh b/build/version_info_macos.sh
index 5970aad..20c863a 100644
--- a/build/version_info_macos.sh
+++ b/build/version_info_macos.sh
@@ -31,7 +31,7 @@ echo "#define __TBB_VERSION_STRINGS(N) \\"
 echo '#N": BUILD_HOST'"\t\t"`hostname -s`" ("`arch`")"'" ENDL \'
 echo '#N": BUILD_OS'"\t\t"`sw_vers -productName`" version "`sw_vers -productVersion`'" ENDL \'
 echo '#N": BUILD_KERNEL'"\t"`uname -v`'" ENDL \'
-echo '#N": BUILD_GCC'"\t\t"`gcc -v </dev/null 2>&1 | grep 'version'`'" ENDL \'
+echo '#N": BUILD_GCC'"\t\t"`gcc --version </dev/null 2>&1 | head -1`'" ENDL \'
 [ -z "$COMPILER_VERSION" ] || echo '#N": BUILD_COMPILER'"\t"$COMPILER_VERSION'" ENDL \'
 echo '#N": BUILD_TARGET'"\t$arch on $runtime"'" ENDL \'
 echo '#N": BUILD_COMMAND'"\t"$*'" ENDL \'
