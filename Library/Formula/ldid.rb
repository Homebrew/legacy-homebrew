require 'formula'

class Ldid < Formula
  url 'http://svn.telesphoreo.org/trunk/data/ldid/ldid-1.0.610.tgz'
  homepage 'http://www.saurik.com/id/8'
  md5 '634c2f8b8a084046883e3793f6580e07'

  def patches
    DATA
  end

  def install
    system "#{ENV.cxx} -I . -o util/ldid{,.cpp} -x c util/{lookup2,sha1}.c"
    bin.install ["util/ldid"]
  end
end

__END__
diff -ur ldid-1.0.610/util/ldid.cpp ldid-1.0.610-p/util/ldid.cpp
--- ldid-1.0.610/util/ldid.cpp	2009-05-20 14:33:45.000000000 +0800
+++ ldid-1.0.610-gm/util/ldid.cpp	2011-10-14 16:58:56.000000000 +0800
@@ -557,6 +557,7 @@
                     case 12: switch (framework->cpusubtype) {
                         case 0: arch = "arm"; break;
                         case 6: arch = "armv6"; break;
+                        case 9: arch = "armv7"; break;
                         default: arch = NULL; break;
                     } break;
 
