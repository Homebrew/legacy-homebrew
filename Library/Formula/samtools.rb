require 'formula'

class Samtools <Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.12/samtools-0.1.12a.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 '500ae32fb431de3940e0e955744b9b36'
  version '0.1.12a'

  def install
    system "make"
    system "make razip"
    bin.install ['samtools', 'razip']
    prefix.install ['examples', 'misc']
    lib.install ['libbam.a']
    (include+'bam').install Dir['*.h']
  end

  def patches
    # dirty fix for "archive has no table of contents" errors
    DATA
  end
end

__END__
diff --git a/Makefile b/Makefile
index 13d4a76..2049049 100644
--- a/Makefile
+++ b/Makefile
@@ -13,6 +13,7 @@ INCLUDES=	-I.
 SUBDIRS=	. bcftools misc
 LIBPATH=
 LIBCURSES=	-lcurses # -lXCurses
+RANLIB=	ranlib
 
 .SUFFIXES:.c .o
 
@@ -40,6 +41,8 @@ libbam.a:$(LOBJS)
 		$(AR) -cru $@ $(LOBJS)
 
 samtools:lib-recur $(AOBJS)
+		 $(RANLIB) libbam.a
+		 $(RANLIB) bcftools/libbcf.a
 		$(CC) $(CFLAGS) -o $@ $(AOBJS) libbam.a -lm $(LIBPATH) $(LIBCURSES) -lz -Lbcftools -lbcf
 
 razip:razip.o razf.o $(KNETFILE_O)

