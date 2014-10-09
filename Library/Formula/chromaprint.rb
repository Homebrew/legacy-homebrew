require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.0.tar.gz'
  sha1 '919e012af588a7e6fea862b29a30e3a5da67526a'
  bottle do
    cellar :any
    sha1 "4cc5cb817710059239610681dfffa91e687e14b0" => :mavericks
    sha1 "3681f1500bae864b7bbbac8d01abe9f1cd0bea50" => :mountain_lion
    sha1 "93e7e29179d55c4d35c7993fd091c46d7aec622a" => :lion
  end

  revision 1

  option 'without-examples', "Don't build examples (including fpcalc)"

  depends_on 'cmake' => :build
  depends_on 'ffmpeg' if build.with? "examples"

  # Upstream patch:
  # https://bitbucket.org/acoustid/chromaprint/commits/d0a8d8bc7c1ad5bda3294836f49184fe34a92454
  patch :DATA

  def install
    args = std_cmake_args
    args << '-DBUILD_EXAMPLES=ON' if build.with? "examples"
    system "cmake", ".", *args
    system "make install"
  end
end

__END__
diff --git a/src/utils.h b/src/utils.h
index 47c6b98..76fb240 100644
--- a/src/utils.h
+++ b/src/utils.h
@@ -28,6 +28,7 @@
 #include <math.h>
 #include <stddef.h>
 #include <stdint.h>
+#include <algorithm>
 #include <limits>
 #include <iterator>
