require 'formula'

class Tnef < Formula
  homepage 'http://sourceforge.net/projects/tnef/'
  url 'http://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.9.tar.gz'
  sha1 'd42ccbe3d41e797fb4133f2e01120680101e8782'

  # LLVM gets confused without a function prototype
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/tnef.c b/src/tnef.c
index 1cb46d1..86aa214 100644
--- a/src/tnef.c
+++ b/src/tnef.c
@@ -57,6 +57,9 @@ typedef enum
     RTF = 'r'
 } MessageBodyTypes;

+// Quick fix for compiling on MacOSX 10.8
+void free_bodies(VarLenData **bodies, int len);
+
 /* Reads and decodes a object from the stream */
 
 static Attr*
