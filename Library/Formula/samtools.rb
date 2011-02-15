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
index 13d4a76..73879b6 100644
--- a/Makefile
+++ b/Makefile
@@ -37,7 +37,7 @@ all:$(PROG)
 lib:libbam.a
 
 libbam.a:$(LOBJS)
-		$(AR) -cru $@ $(LOBJS)
+		$(AR) -s -cru $@ $(LOBJS)
 
 samtools:lib-recur $(AOBJS)
 		$(CC) $(CFLAGS) -o $@ $(AOBJS) libbam.a -lm $(LIBPATH) $(LIBCURSES) -lz -Lbcftools -lbcf
diff --git a/bcftools/Makefile b/bcftools/Makefile
index 8b890ba..5751e74 100644
--- a/bcftools/Makefile
+++ b/bcftools/Makefile
@@ -28,7 +28,7 @@ all:$(PROG)
 lib:libbcf.a
 
 libbcf.a:$(LOBJS)
-		$(AR) -cru $@ $(LOBJS)
+		$(AR) -s -cru $@ $(LOBJS)
 
 bcftools:lib $(AOBJS)
 		$(CC) $(CFLAGS) -o $@ $(AOBJS) -lm $(LIBPATH) -lz -L. -lbcf

