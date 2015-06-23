class Phash < Formula
  desc "Perceptual hash library"
  homepage "http://www.phash.org/"
  url "http://phash.org/releases/pHash-0.9.6.tar.gz"
  sha256 "3c8258a014f9c2491fb1153010984606805638a45d00498864968a9a30102935"
  revision 1

  bottle do
    cellar :any
    sha1 "d5cd584f04669d06d1876704546bc56bc71aa754" => :mavericks
    sha1 "7a5320740e97de701e924c6c2dbeecb179438f1c" => :mountain_lion
    sha1 "9c8ecf5f7b7774cec34059f8a2e02d3d6644368e" => :lion
  end

  option "disable-image-hash", "Disable image hash"
  option "disable-video-hash", "Disable video hash"
  option "disable-audio-hash", "Disable audio hash"

  depends_on "cimg" unless build.include? "disable-image-hash" and build.include? "disable-video-hash"
  depends_on "ffmpeg" unless build.include? "disable-video-hash"

  unless build.include? "disable-audio-hash"
    depends_on "libsndfile"
    depends_on "libsamplerate"
    depends_on "mpg123"
  end

  fails_with :clang do
    build 318
    cause "configure: WARNING: CImg.h: present but cannot be compiled"
  end

  def install
    inreplace "src/ph_fft.h", "/usr/include/complex.h", "#{MacOS.sdk_path}/usr/include/complex.h"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-shared
    ]

    args << "--disable-image-hash" if build.include? "disable-image-hash"
    args << "--disable-video-hash" if build.include? "disable-video-hash"
    args << "--disable-audio-hash" if build.include? "disable-audio-hash"

    system "./configure", *args
    system "make", "install"
  end
end
