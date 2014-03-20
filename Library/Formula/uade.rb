require 'formula'

class Uade < Formula
  homepage 'http://zakalwe.fi/uade/'

  stable do
    url "http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2"
    sha1 "61c5ce9dfecc37addf233de06be196c9b15a91d8"

    # Upstream patch to fix compiler detection under superenv
    patch :DATA
  end

  head 'git://zakalwe.fi/uade'

  depends_on 'pkg-config' => :build
  depends_on 'libao'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 05bfa9b..a73608e 100755
--- a/configure
+++ b/configure
@@ -399,13 +399,13 @@ if test -n "$sharedir"; then
     uadedatadir="$sharedir"
 fi
 
-$NATIVECC -v 2>/dev/null >/dev/null
+$NATIVECC --version 2>/dev/null >/dev/null
 if test "$?" != "0"; then
     echo Native CC "$NATIVECC" not found, please install a C compiler
     exit 1
 fi
 
-$TARGETCC -v 2>/dev/null >/dev/null
+$TARGETCC --version 2>/dev/null >/dev/null
 if test "$?" != "0"; then
     echo Target CC "$TARGETCC" not found, please install a C compiler
     exit 1
