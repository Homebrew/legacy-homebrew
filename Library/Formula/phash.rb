require 'formula'

class Phash < Formula
  homepage 'http://www.phash.org/'
  url 'http://phash.org/releases/pHash-0.9.6.tar.gz'
  sha1 '26f4c1e7ca6b77e6de2bdfce490b2736d4b63753'

  depends_on 'cimg' unless build.include? "disable-image-hash" and build.include? "disable-video-hash"
  depends_on 'ffmpeg' unless build.include? "disable-video-hash"

  unless build.include? "disable-audio-hash"
    depends_on 'libsndfile'
    depends_on 'libsamplerate'
    depends_on 'mpg123'
  end

  option "disable-image-hash", "Disable image hash"
  option "disable-video-hash", "Disable video hash"
  option "disable-audio-hash", "Disable audio hash"

  fails_with :clang do
    build 318
    cause "configure: WARNING: CImg.h: present but cannot be compiled"
  end

  # Original code imports </usr/include/complex.h>
  # We change it to <complex.h>
  def patches
    DATA
  end

  def install
    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --enable-shared
            ]

    # disable specific hashes if specified as an option
    args << "--disable-image-hash" if build.include? "disable-image-hash"
    args << "--disable-video-hash" if build.include? "disable-video-hash"
    args << "--disable-audio-hash" if build.include? "disable-audio-hash"

    system "./configure", *args
    system "make install"
  end
end

__END__
diff -crB pHash-0.9.6_ori/src/ph_fft.h pHash-0.9.6/src/ph_fft.h
*** pHash-0.9.6_ori/src/ph_fft.h	2011-08-02 07:23:43.000000000 +0200
--- pHash-0.9.6/src/ph_fft.h	2013-10-10 09:29:05.000000000 +0200
***************
*** 29,35 ****
  #define PI 3.1415926535897932
  
  #include <math.h>
! #include </usr/include/complex.h>
  #include <stdlib.h>
  
  int fft(double *x, int N, complex double *X);
--- 29,35 ----
  #define PI 3.1415926535897932
  
  #include <math.h>
! #include <complex.h>
  #include <stdlib.h>
  
  int fft(double *x, int N, complex double *X);
