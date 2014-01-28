require 'formula'

class Pocl < Formula
  homepage 'http://pocl.sourceforge.net'
  url 'http://pocl.sourceforge.net/downloads/pocl-0.8.tar.gz'
  sha1 '773f761bdca4c53654cfc0e59363e01757735c8b'

  depends_on 'pkg-config' => :build
  depends_on 'hwloc'
  depends_on 'llvm' => 'with-clang'
  depends_on :libltdl

  def patches
    # fix llvm-link command in script with version found by
    # configure. This should be fixed in 0.9
    DATA
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--enable-direct-linkage",
                          "--disable-icd",
                          "--enable-testsuites=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'foo.cl').write <<-EOS.undent
      kernel void foo(int *in, int *out) {
        int i = get_global_id(0);
        out[i] = in[i];
      }
    EOS
    system "#{bin}/pocl-standalone -h head.h -o foo.bc foo.cl"
    system "\"#{Formula.factory('llvm').opt_prefix}/bin/llvm-dis\" < foo.bc | grep foo_workgroup"
    system "pkg-config pocl --modversion | grep 0.8"
  end
end

__END__
diff --git a/scripts/pocl-standalone.in b/scripts/pocl-standalone.in
index 739fc4b..9542bf3 100644
--- a/scripts/pocl-standalone.in
+++ b/scripts/pocl-standalone.in
@@ -106,7 +106,7 @@ pocl_lib="@abs_top_builddir@/lib/llvmopencl/.libs/llvmopencl.so"
 full_target_dir="@abs_top_builddir@/lib/kernel/${target_dir}"
 # END REMOVE ONCE INSTALLED

-llvm-link -o ${linked_bc} ${kernel_bc} ${full_target_dir}/kernel*.bc
+@LLVM_LINK@ -o ${linked_bc} ${kernel_bc} ${full_target_dir}/kernel*.bc

 OPT_SWITCH="-O3"
