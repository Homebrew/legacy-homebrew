require 'formula'

class Phash < Formula
  homepage 'http://www.phash.org/'
  url 'http://www.phash.org/releases/pHash-0.9.5.tar.gz'
  sha1 '87ce165b344bb859f5fdaf7c1776b556db3d8a15'

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
