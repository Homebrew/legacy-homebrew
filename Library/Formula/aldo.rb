require 'formula'

class Aldo < Formula
  url 'http://savannah.nongnu.org/download/aldo/aldo-0.7.6.tar.bz2'
  homepage 'http://www.nongnu.org/aldo/'
  md5 'c870b62fe50f71eb6c7ddcd5d666d2e2'

  depends_on 'libao'

  def patches
    # Fixes crash due to added field in libao-1.0.
    # See:
    #   http://calypso.tux.org/pipermail/novalug/2011-March/027843.html
    #   https://savannah.nongnu.org/patch/index.php?7716
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/audioworkspace.cc b/src/audioworkspace.cc
index c8dd68a..d786e04 100644
--- a/src/audioworkspace.cc
+++ b/src/audioworkspace.cc
@@ -31,6 +31,7 @@ Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006, 2007 Giuseppe "denever" Martin
 #include <cmath>
 #include <iostream>
 #include <limits>
+#include <string.h>
     
 using namespace std;
 using namespace libaudiostream;
@@ -104,10 +105,12 @@ oastream AudioWorkSpace::create_output_stream()
 {
     ao_sample_format format;
     
+    memset(&format, '0', sizeof(format));
     format.bits = m_bits;
     format.channels = m_channels;
     format.rate = m_sample_rate;
     format.byte_format = AO_FMT_LITTLE;
+    format.matrix = NULL;
 
     return oastream(format, m_device);
 }
