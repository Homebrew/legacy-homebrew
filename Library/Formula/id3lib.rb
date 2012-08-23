require 'formula'

class Id3lib < Formula
  url 'http://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz'
  head "cvs://:pserver:anonymous@id3lib.cvs.sourceforge.net:/cvsroot/id3lib:id3lib-devel"
  homepage 'http://id3lib.sourceforge.net/'
  sha1 'c92c880da41d1ec0b242745a901702ae87970838'

  def patches
    p = []
    p << DATA unless ARGV.build_head?
    # Fix main defined with unsigned int instead of int
    p << "https://trac.macports.org/export/90780/trunk/dports/audio/id3lib/files/id3lib-main.patch"
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

# Wrong header size... I believe this bug is fixed in id3lib HEAD. See:
# http://sourceforge.net/tracker/index.php?func=detail&amp;aid=697951&amp;group_id=979&amp;atid=100979
__END__
diff --git a/src/mp3_parse.cpp b/src/mp3_parse.cpp
index 41d8560..fc8992b 100755
--- a/src/mp3_parse.cpp
+++ b/src/mp3_parse.cpp
@@ -465,7 +465,7 @@ bool Mp3Info::Parse(ID3_Reader& reader, size_t mp3size)
   // from http://www.xingtech.com/developer/mp3/
 
   const size_t VBR_HEADER_MIN_SIZE = 8;     // "xing" + flags are fixed
-  const size_t VBR_HEADER_MAX_SIZE = 116;   // frames, bytes, toc and scale are optional
+  const size_t VBR_HEADER_MAX_SIZE = 120;   // frames, bytes, toc and scale are optional
 
   if (mp3size >= vbr_header_offest + VBR_HEADER_MIN_SIZE) 
   {
