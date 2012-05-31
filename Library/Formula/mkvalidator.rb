require 'formula'

class Mkvalidator < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.3.7.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  sha1 '4dada51d23255dffb4176450b410d6326a72d845'

  def patches
    # see https://sourceforge.net/tracker/?group_id=68739&atid=522230
    DATA if MacOS.prefer_64_bit?
  end

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end

__END__
--- a/corec/tools/coremake/gcc_osx_x64.build	2011-09-25 08:01:47.000000000 -0700
+++ b/corec/tools/coremake/gcc_osx_x64.build	2012-03-15 17:17:44.000000000 -0700
@@ -4,9 +4,9 @@
 
 PLATFORMLIB = osx_x86
 SVNDIR = osx_x86
-SDK = /Developer/SDKs/MacOSX10.6.sdk
 
-CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic -mmacosx-version-min=10.6
+
+CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic
 ASMFLAGS = -f macho64 -D_MACHO
 
 #include "gcc_osx.inc"
