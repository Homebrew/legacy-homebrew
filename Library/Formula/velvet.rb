require 'formula'

class Velvet < Formula
  url 'https://github.com/dzerbino/velvet/tarball/b19ee2d5a180c745a6b44fd0d27c3d36dd80a7a9'
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  md5 '8772b8c2c8071dc62541bc969bcd4490'
  version '1.1.05'

  head 'https://github.com/dzerbino/velvet.git', :using  => :git

  def patches
    # Makefile recommends uncommenting a line for compiling on Mac OS X
    DATA
  end

  def install
    system "make velveth velvetg OPENMP=1 MAXKMERLENGTH=1 LONGSEQUENCES=1"
    bin.install ['velveth', 'velvetg']
  end
end

__END__
diff --git a/Makefile b/Makefile
index a8ca8c0..16fb62a 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ CATEGORIES=2
 DEF = -D MAXKMERLENGTH=$(MAXKMERLENGTH) -D CATEGORIES=$(CATEGORIES)
 
 # Mac OS users: uncomment the following lines
-# CFLAGS = -Wall -m64
+CFLAGS = -Wall -m64
 
 # Sparc/Solaris users: uncomment the following line
 # CFLAGS = -Wall -m64
