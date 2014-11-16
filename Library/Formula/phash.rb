require 'formula'

class Phash < Formula
  homepage 'http://www.phash.org/'
  url 'http://phash.org/releases/pHash-0.9.6.tar.gz'
  sha1 '26f4c1e7ca6b77e6de2bdfce490b2736d4b63753'
  bottle do
    cellar :any
    sha1 "d5cd584f04669d06d1876704546bc56bc71aa754" => :mavericks
    sha1 "7a5320740e97de701e924c6c2dbeecb179438f1c" => :mountain_lion
    sha1 "9c8ecf5f7b7774cec34059f8a2e02d3d6644368e" => :lion
  end

  revision 1

  option "disable-image-hash", "Disable image hash"
  option "disable-video-hash", "Disable video hash"
  option "disable-audio-hash", "Disable audio hash"

  depends_on 'cimg' unless build.include? "disable-image-hash" and build.include? "disable-video-hash"
  depends_on 'ffmpeg' unless build.include? "disable-video-hash"

  unless build.include? "disable-audio-hash"
    depends_on 'libsndfile'
    depends_on 'libsamplerate'
    depends_on 'mpg123'
  end

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
