require 'formula'

class Hunspell <Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.2.12.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  md5 '5ef2dc1026660d0ffb7eae7b511aee23'

  depends_on 'readline'

  def patches
    # Change Hunspell's dictionary path to use dictionaries installed
    # in /Library/Spelling or ~/Library/Spelling, which is used by OS X.
    # See also this Hunspell feature request:
    # http://sourceforge.net/tracker/?func=detail&aid=3142010&group_id=143754&atid=756398
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--with-ui", "--with-readline",
           "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end

__END__
diff --git a/src/tools/hunspell.cxx b/src/tools/hunspell.cxx
index 827f75b..582a1f3 100644
--- a/src/tools/hunspell.cxx
+++ b/src/tools/hunspell.cxx
@@ -61,10 +61,12 @@
 #include "firstparser.hxx"
 
 #define LIBDIR \
+    "/Library/Spelling:" \
     "/usr/share/hunspell:" \
     "/usr/share/myspell:" \
     "/usr/share/myspell/dicts"
 #define USEROOODIR \
+    "Library/Spelling:" \
     ".openoffice.org/3/user/wordbook:" \
     ".openoffice.org2/user/wordbook:" \
     ".openoffice.org2.0/user/wordbook"
