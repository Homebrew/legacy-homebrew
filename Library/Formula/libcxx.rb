require 'formula'

class Libcxx < Formula
  homepage 'http://libcxx.llvm.org'
  head 'http://llvm.org/svn/llvm-project/libcxx/trunk',
       :using => StrictSubversionDownloadStrategy

  depends_on 'libcppabi'
  depends_on 'llvm'

  def patches
    DATA
  end

  def install
    system "cd lib; env TRIPLE=-apple- CXX=clang++ ./buildit"
    ln_s 'lib/libc++.1.dylib', 'lib/libc++.dylib'
    lib.install %w[lib/libc++.1.dylib lib/libc++.dylib]
    (prefix+'include/c++/v1').install 'include'
  end
end

__END__
--- a/lib/buildit
+++ b/lib/buildit
@@ -40,8 +40,8 @@
 		LDSHARED_FLAGS="-o libc++.1.dylib \
 			-dynamiclib -nodefaultlibs -current_version 1 \
 			-compatibility_version 1 \
-			-install_name /usr/lib/libc++.1.dylib \
-			-Wl,-reexport_library,/usr/lib/libc++abi.dylib \
+			-install_name /usr/local/lib/libc++.1.dylib \
+			-Wl,-reexport_library,/usr/local/lib/libc++abi.dylib \
 			-Wl,-unexported_symbols_list,libc++unexp.exp  \
 			/usr/lib/libSystem.B.dylib"
 	else
