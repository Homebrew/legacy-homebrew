require 'formula'

class DvdxrwTools <Formula
  url 'http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz'
  homepage 'http://fy.chalmers.se/~appro/linux/DVD+RW/'
  md5 '8acb3c885c87f6838704a0025e435871'

  def patches
    # Respect $PREFIX
    DATA
  end

  def install
    bin.mkdir
    man1.mkpath
    system "make PREFIX=#{prefix} install"
  end
end

__END__
diff --git a/Makefile.m4 b/Makefile.m4
index a6a100b..bf7c041 100644
--- a/Makefile.m4
+++ b/Makefile.m4
@@ -30,8 +30,8 @@ LINK.o	=$(LINK.cc)
 # to install set-root-uid, `make BIN_MODE=04755 install'...
 BIN_MODE?=0755
 install:	dvd+rw-tools
-	install -o root -m $(BIN_MODE) $(CHAIN) /usr/bin
-	install -o root -m 0644 growisofs.1 /usr/share/man/man1
+	install -m $(BIN_MODE) $(CHAIN) $(PREFIX)/bin
+	install -m 0644 growisofs.1 $(PREFIX)/share/man/man1
 ])
 
 ifelse(OS,MINGW32,[
