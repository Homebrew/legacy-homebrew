require 'formula'

class Ilmbase <Formula
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-1.0.1.tar.gz'
  homepage 'http://www.openexr.com/'
  md5 'f76f094e69a6079b0beb93d97e2a217e'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -21049,7 +21049,7 @@ Please re-run configure with these options:
     CXXFLAGS="$CXXFLAGS -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch ppc -arch i386"
       fi
 
-  CXXFLAGS="$CXXFLAGS -Wno-long-double"
+  CXXFLAGS="$CXXFLAGS"
   ;;
 esac
 

