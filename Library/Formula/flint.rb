require 'formula'

class Flint < Formula
  homepage 'http://www.flintlib.org/'

  head 'https://github.com/wbhart/flint2.git', :branch => 'trunk'

  url 'http://www.flintlib.org/flint-2.3.tar.gz'
  sha1 '58534b28ba30e63b183476b2b914cb767d1ec919'

  depends_on 'mpir'
  depends_on 'mpfr'

  def patches
    # Fix library name on Darwin64
    DATA if version.to_s == '2.3'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--reentrant"

    system "make"
    system "make", "install"
  end

  def test
    system "make", "check"
  end

  fails_with :gcc do
    build 463
    cause <<-EOS.undent
      Configuration step: Testing native popcount...no
      EOS
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Configuration step: Testing __builtin_popcountl...no
      EOS
  end
end

__END__
diff --git a/configure b/configure
index 0e79674..30a4755 100755
--- a/configure
+++ b/configure
@@ -225,12 +225,7 @@ echo "Configuring...${MACHINE}-${OS}"
 if [ -z "$FLINT_LIB" ]; then
    case $OS in
       Darwin)
-         case $MACHINE in
-            *64)
-               FLINT_LIB="libflint.dylib64";;
-            *)
-               FLINT_LIB="libflint.dylib";;
-         esac;;
+         FLINT_LIB="libflint.dylib";;
       CYGWIN | MINGW*)
          FLINT_LIB="libflint.dll";;
       *)
