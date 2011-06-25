require 'formula'

class Tintin < Formula
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.00.6/tintin-2.00.6.tar.gz'
  homepage 'http://tintin.sf.net'
  md5 '96c8505ad2b28ff9189eff02de89de25'

  # From version 1.91.1, pcre is required to compile TinTin++
  #   http://tintin.sourceforge.net/board/viewtopic.php?t=786
  depends_on 'pcre'

  def patches
    # This puts brew's environ (CPPFLAGS and CFLAGS) in generated Makefile
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
