require 'formula'

class Openexr <Formula
  url 'http://download.savannah.gnu.org/releases/openexr/openexr-1.6.1.tar.gz'
  homepage 'http://www.openexr.com/'
  md5 '11951f164f9c872b183df75e66de145a'

  depends_on 'pkg-config' => :build
  depends_on 'ilmbase'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -21504,7 +21504,7 @@ Please re-run configure with these options:
     CXXFLAGS="$CXXFLAGS -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch ppc -arch i386"
       fi
 
-  CXXFLAGS="$CXXFLAGS -Wno-long-double"
+  CXXFLAGS="$CXXFLAGS"
   ;;
 esac
