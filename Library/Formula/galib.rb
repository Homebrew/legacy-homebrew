require 'formula'

class Galib < Formula
  homepage 'http://lancet.mit.edu/ga/'
  url 'http://lancet.mit.edu/ga/dist/galib247.tgz'
  version '2.4.7'
  sha1 '3411da19d6b5b67638eddc4ccfab37a287853541'

  def install
    system "make"
    system "make install"
  end

  def test
    system "make test"
  end

  def patches
    # Enable ranlib
    DATA
  end
end

__END__
diff --git a/makevars b/makevars
index ad27450..4b60073 100644
--- a/makevars
+++ b/makevars
@@ -36,7 +36,7 @@ CXXFLAGS    = -g -Wall
 LD          = g++ -w
 AR          = ar rv
 INSTALL     = install -c
-RANLIB      = echo no ranlib
+RANLIB      = ranlib
 
 # gcc2
 #  verified 28dec04 on linux-x86 (redhat 6.2 with gcc 2.95.2)
 