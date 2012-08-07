require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'http://sourceforge.net/projects/ccextractor/files/ccextractor/0.62/ccextractor.src.0.62.zip/'
  sha1 'fbda805f1ecbb7d2d662ac0d7df78dbf284f9e7b'

  def patches
    # Fixes duplicate ) in build command
    DATA
  end

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end

  def test
    system "ccextractor"
  end
end

__END__
diff --git a/mac/build.command b/mac/build.command
index 2699b46..d7e9cea 100644
--- a/mac/build.command
+++ b/mac/build.command
@@ -1 +1 @@
-g++ -Dfopen64=fopen -Dopen64=open -Dlseek64=lseek -I../src/gpacmp4 -o ccextractor $(find ../src/ -name '*.cpp')) $(find ../src/ -name '*.c')
+g++ -Dfopen64=fopen -Dopen64=open -Dlseek64=lseek -I../src/gpacmp4 -o ccextractor $(find ../src/ -name '*.cpp') $(find ../src/ -name '*.c')

