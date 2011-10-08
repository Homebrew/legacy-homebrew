require 'formula'

class Clit < Formula
  url 'http://www.convertlit.com/clit18src.zip'
  homepage 'http://www.convertlit.com'
  md5 'd691d4729485fe5d73e3f0937d8fb42e'

  version '1.8'

  depends_on 'libtommath'

  def install
    system 'make -C lib'
    system 'make -C clit18'
    bin.install 'clit18/clit'
  end

  def patches
    # Fixing the makefiles
    DATA
  end
end

__END__
diff --git a/clit18/Makefile b/clit18/Makefile
index d0acaa3..17b3b43 100644
--- a/clit18/Makefile
+++ b/clit18/Makefile
@@ -5,5 +5,5 @@ clean:
 	rm -f *.o clit
 
 clit: clit.o hexdump.o drm5.o explode.o transmute.o display.o utils.o manifest.o ../lib/openclit.a 
-	gcc -o clit $^  ../libtommath-0.30/libtommath.a
+	gcc -ltommath -o clit $^
 
diff --git a/lib/Makefile b/lib/Makefile
index 9104f27..8e665f8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,4 +7,5 @@ clean:
 openclit.a: litatom.o litdrm.o litlib.o litembiggen.o littags.o litmetatags.o litmanifest.o litdirectory.o litsections.o litheaders.o litutil.o sha/mssha1.o des/des.o newlzx/lzxglue.o newlzx/lzxd.o
 	-rm -f openclit.a
 	ar rv openclit.a $^
+	ranlib openclit.a
 
