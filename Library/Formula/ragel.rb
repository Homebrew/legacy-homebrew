require 'formula'

class Ragel < Formula
  homepage 'http://www.complang.org/ragel/'
  url 'http://www.complang.org/ragel/ragel-6.8.tar.gz'
  sha1 '95cabbcd52bd25d76c588ddf11e1fd242d7cbcc7'

  resource 'pdf' do
    url 'http://www.complang.org/ragel/ragel-guide-6.8.pdf'
    sha1 'e57ee7f740dd395d4d5330949594a02c91ad0308'
  end

  # Fix compilation with recent clang, patch from upstream git repo
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    doc.install resource('pdf')
  end
end

__END__
diff --git a/ragel/javacodegen.cpp b/ragel/javacodegen.cpp
index adff67e..ff2193c 100644
--- a/ragel/javacodegen.cpp
+++ b/ragel/javacodegen.cpp
@@ -54,6 +54,7 @@ using std::cin;
 using std::cout;
 using std::cerr;
 using std::endl;
+using std::setiosflags;
 
 void javaLineDirective( ostream &out, const char *fileName, int line )
 {
