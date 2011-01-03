require 'formula'

class Subtitleripper <Formula
  url 'http://downloads.sourceforge.net/project/subtitleripper/subtitleripper/subtitleripper-0.3/subtitleripper-0.3.tgz'
  homepage 'http://subtitleripper.sourceforge.net/'
  md5 'a727abdf31564eb3f98af6aba3dcc234'

  depends_on 'transcode'
  depends_on 'netpbm'
  depends_on 'libpng'

  def install
    ENV.libpng

    system "make"

    bin.install 'subtitle2pgm'
    bin.install 'srttool'
    bin.install 'subtitle2vobsub'
  end

  def patches
    # The given patch fixes the make file to use the proper
    # libpng package
    DATA
  end
end
__END__
--- 1/Makefile	2010-09-26 22:52:29.000000000 -0400
+++ 2/Makefile	2010-09-26 22:53:32.000000000 -0400
@@ -4,8 +4,8 @@
 
 # use always:
 DEFINES :=  
-LIBS    := -lm 
-INCLUDES :=
+LIBS    := ${LDFLAGS} -lm 
+INCLUDES := ${CPPFLAGS}
 
 ### enable ppm support ###
 DEFINES  += -D_HAVE_LIB_PPM_
