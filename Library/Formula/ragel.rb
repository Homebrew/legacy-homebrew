require 'formula'

class Ragel < Formula
  homepage 'http://www.complang.org/ragel/'
  url 'http://www.complang.org/ragel/ragel-6.8.tar.gz'
  sha1 '95cabbcd52bd25d76c588ddf11e1fd242d7cbcc7'

  resource 'pdf' do
    url 'http://www.complang.org/ragel/ragel-guide-6.8.pdf'
    sha1 'e57ee7f740dd395d4d5330949594a02c91ad0308'
  end
  def patches
    DATA
  end
  
  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    doc.install resource('pdf')
  end
end


__END__
--- ragel-6.8/ragel/javacodegen.cpp	2013-02-11 02:57:45.000000000 +0100
+++ ragel-6.8-new/ragel/javacodegen.cpp	2013-10-28 00:30:32.000000000 +0100
@@ -1184,7 +1184,7 @@ std::ostream &JavaTabCodeGen::ARRAY_ITEM
 {
 	item_count++;
 
-	out << setw(5) << setiosflags(ios::right) << item;
+	out << setw(5) << std::setiosflags(ios::right) << item;
 	
 	if ( !last ) {
 		if ( item_count % SAIIC == 0 ) {
