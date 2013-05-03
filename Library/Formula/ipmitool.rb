require 'formula'

class Ipmitool < Formula
  homepage 'http://ipmitool.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.12/ipmitool-1.8.12.tar.bz2'
  sha1 'b895564db1196e891b60d2ab4f6d0bf5499c3453'

  # Project uses -Wno-unused-result and -Wno-packed-bitfield-compat, which were
  # introduced in gcc-4.4 and don't work on Apple gcc or llvm-gcc
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index bdf6dae..f5b8e8d 100755
--- a/configure
+++ b/configure
@@ -5030,7 +5030,7 @@ fi
 done
 
 
-CFLAGS="$CFLAGS -fno-strict-aliasing -Wreturn-type -Wno-unused-result -Wno-packed-bitfield-compat"
+CFLAGS="$CFLAGS -fno-strict-aliasing -Wreturn-type"
 
 case `pwd` in
   *\ * | *\  *)
