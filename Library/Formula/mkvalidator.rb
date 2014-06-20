require 'formula'

class Mkvalidator < Formula
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  url 'https://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.4.2.tar.bz2'
  sha1 'e0e431e6ca7011e7e4547f3166e532553a1d6a79'

  # see https://sourceforge.net/tracker/?group_id=68739&atid=522230
  patch :DATA if MacOS.prefer_64_bit?

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end

__END__
--- a/corec/tools/coremake/gcc_osx_x64.build	2012-05-13 00:39:54.000000000 -0700
+++ b/corec/tools/coremake/gcc_osx_x64.build	2012-06-14 01:43:02.000000000 -0700
@@ -4,7 +4,6 @@
 
 PLATFORMLIB = osx_x86
 SVNDIR = osx_x86
-SDK = /Developer/SDKs/MacOSX10.6.sdk
 
 CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic -mmacosx-version-min=10.6
 ASMFLAGS = -f macho64 -D_MACHO
