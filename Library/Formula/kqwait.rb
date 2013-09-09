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
    bin.install "kqwait"
  end
  
  test do
    system "#{bin}/kqwait", "-v"
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
