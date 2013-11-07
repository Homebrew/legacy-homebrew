require 'formula'

class Dub < Formula
  homepage 'http://registry.vibed.org/'
  url  'https://github.com/rejectedsoftware/dub/archive/v0.9.19.tar.gz'
  sha1 'dcf880029190180a1a4a4753237c0eb164941c98'

  head 'https://github.com/rejectedsoftware/dub.git'

  depends_on 'pkg-config' => :build
  depends_on 'dmd'  => :build

  def patches; DATA; end

  def install
    system "./build.sh"
    bin.install 'bin/dub'
  end

  test do
    system "#{bin}/dub; true"
  end
end

__END__
diff --git a/build.sh b/build.sh
index dce1766..eacc765 100755
--- a/build.sh
+++ b/build.sh
@@ -16,11 +16,11 @@ fi
 LIBS=`pkg-config --libs libcurl 2>/dev/null || echo "-lcurl"`

 # fix for modern GCC versions with --as-needed by default
-if [ "$DC" = "dmd" ]; then
-	LIBS="-l:libphobos2.a $LIBS"
-elif [ "$DC" = "ldmd2" ]; then
-	LIBS="-lphobos-ldc $LIBS"
-fi
+# if [ "$DC" = "dmd" ]; then
+#     LIBS="-l:libphobos2.a $LIBS"
+# elif [ "$DC" = "ldmd2" ]; then
+#     LIBS="-lphobos-ldc $LIBS"
+# fi

 # adjust linker flags for dmd command line
 LIBS=`echo "$LIBS" | sed 's/^-L/-L-L/; s/ -L/ -L-L/g; s/^-l/-L-l/; s/ -l/ -L-l/g'`
