require 'formula'

class Kqwait < Formula
  homepage 'https://github.com/sschober/kqwait'
  url 'https://github.com/sschober/kqwait.git', :tag => 'kqwait-v1.0.2'
  sha1 '7b4e762de8867593b21b06908a6ee13dbc1c863a'
  
  head 'https://github.com/sschober/kqwait.git'
  
  def patches
    DATA
  end
  
  def install
    system "make"
    bin.install('kqwait')
  end
  
  test do
    system "kqwait", "-v"
  end
end

__END__

diff --git a/Makefile b/Makefile
index 91c210e..c8c65b2 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ version.h:
 dirinfo.o: dirinfo.c
 	cc $(OPTS) -c -o $@ $<
 
-$(trg): $(src) dirinfo.o version.h
+$(trg): $(src) dirinfo.o
 	cc $(OPTS) -o $@ dirinfo.o $<
 
 clean:

diff --git a/version.h b/version.h
new file mode 100644
index 0000000..10a0ed6
--- /dev/null
+++ b/version.h
@@ -0,0 +1,4 @@
+#ifndef VERSION_H
+#define VERSION_H
+#define VERSION "v1.0.2-1-g0425-dirty"
+#endif
