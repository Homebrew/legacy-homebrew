class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.7.tar.bz2"
  sha256 "88713065a172d1ab7fd34c8854a42f6bf8d0e794957265340328a2f692ad46d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8628b1bfb08d1624faa2037d199592bc6209759322bcfc53eb5649ad304e4bd" => :el_capitan
    sha256 "cefecf33d4cb9fa15d582b0d03c26cf3a14228d02832ddbf3187d5c4ffd4a4c2" => :yosemite
    sha256 "51b53b0e49a5fe451c6bd3589e780e51ac23c637493c8804233057cb79b9d40d" => :mavericks
  end

  # Fixes compile error with XCode-4.3+, a hardcoded /Developer.  Reported as:
  # https://sourceforge.net/tracker/?func=detail&aid=3505611&group_id=68739&atid=522228
  patch :DATA if MacOS.prefer_64_bit?

  def install
    ENV.deparallelize # Otherwise there are races
    system "./configure"
    system "make -C mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install Dir["release/#{bindir}/mk*"]
  end
end

__END__
--- a/corec/tools/coremake/gcc_osx_x64.build	2011-09-25 02:25:46.000000000 -0700
+++ b/corec/tools/coremake/gcc_osx_x64.build	2012-03-15 16:27:46.000000000 -0700
@@ -4,9 +4,9 @@
 
 PLATFORMLIB = osx_x86
 SVNDIR = osx_x86
-SDK = /Developer/SDKs/MacOSX10.6.sdk
 
-CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic -mmacosx-version-min=10.6
+
+CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic
 ASMFLAGS = -f macho64 -D_MACHO
 
 #include "gcc_osx.inc"
