class Phash < Formula
  desc "Perceptual hash library"
  homepage "http://www.phash.org/"
  url "http://phash.org/releases/pHash-0.9.6.tar.gz"
  sha256 "3c8258a014f9c2491fb1153010984606805638a45d00498864968a9a30102935"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "04330b396a9e60bf8df72aa9074fe8b1d9cd5a14605c6ea19b3d948155d399f1" => :el_capitan
    sha256 "6ef0c1a1f65955e55481268c3918df4b74014aedf4607056b6b66a81b233b307" => :yosemite
    sha256 "58fbfeaabbdcdc588698dd3f5d9d7c7699cfcc66a580ee0bd925d9b804e9fad7" => :mavericks
  end

  option "without-image-hash", "Disable image hash"
  option "without-video-hash", "Disable video hash"
  option "without-audio-hash", "Disable audio hash"

  deprecated_option "disable-image-hash" => "without-image-hash"
  deprecated_option "disable-video-hash" => "without-video-hash"
  deprecated_option "disable-audio-hash" => "without-audio-hash"

  depends_on "cimg" if build.with?("image-hash") || build.with?("video-hash")
  depends_on "ffmpeg" if build.with? "video-hash"

  if build.with? "audio-hash"
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

    args << "--disable-image-hash" if build.without? "image-hash"
    args << "--disable-video-hash" if build.without? "video-hash"
    args << "--disable-audio-hash" if build.without? "audio-hash"

    system "./configure", *args
    system "make", "install"
  end
end
