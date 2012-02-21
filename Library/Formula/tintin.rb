require 'formula'

class Tintin < Formula
  homepage 'http://tintin.sf.net'
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.00.8/tintin-2.00.8.tar.gz'
  sha256 'e364a7fa7ed35a2d166a081cce4682d5fe2481ee9ce72c6a409903d097e1ae45'

  depends_on 'pcre'

  # This puts brew's environ (CPPFLAGS and CFLAGS) in generated Makefile
  def patches
    DATA
  end

  def install
    Dir.chdir "src"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index 067b5ff..d55bc74 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -31,11 +31,11 @@ docdir = @prefix@/doc
 
 #this is the standard CFLAGS options, this is what most people should use
 
-CFLAGS += $(DEFINES) @BIG5@
+CFLAGS += $(DEFINES) @CFLAGS@ @BIG5@
 
 LDFLAGS = @LDFLAGS@
 
-INCS = @MYINCLUDE@
+INCS = @CPPFLAGS@ @MYINCLUDE@
 
 LIBS = @MYLIB@ @LIBS@
