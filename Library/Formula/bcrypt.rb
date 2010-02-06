require 'formula'

class Bcrypt <Formula
  url 'http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz'
  homepage 'http://bcrypt.sourceforge.net'
  md5 '8ce2873836ccd433329c8df0e37e298c'

  def patches
    DATA
  end

  def install
    system "make"
    system "make install"
  end

end
__END__
diff --git a/Makefile b/Makefile
index b84da0f..96d07e2 100644
--- a/Makefile
+++ b/Makefile
@@ -3,8 +3,8 @@ CC = gcc
 CFLAGS = -O2 -Wall 
 COMPILE = ${CC} ${CFLAGS}
 OBJS = main.o blowfish.o rwfile.o keys.o wrapbf.o endian.o wrapzl.o
-LDFLAGS = -L/usr/local/lib -lz 
-PREFIX = /usr/local
+LDFLAGS = -L`brew --prefix`/lib -lz 
+PREFIX = `brew --prefix`/Cellar/bcrypt/1.1
 
 bcrypt:        ${OBJS} Makefile
        ${COMPILE} -o bcrypt ${OBJS} ${LDFLAGS}
