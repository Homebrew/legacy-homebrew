class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.22.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/f/ffms2/ffms2_2.22.orig.tar.gz"
  sha256 "7c5202fa2e49186fb3bb815e5b12ca71f05ec09cb707ffd9465852e21a06fdad"

  bottle do
    cellar :any
    sha256 "b48b3b7b10eb88a08a5556f40a71deb0ac10d62e89a681b3d9577ad32229023e" => :yosemite
    sha256 "857d0e62a8120ef2fd00327862f7a6b8afb8755082e14f2ac5d600c84b6819d7" => :mavericks
    sha256 "cf9039480a3baf42907ed3082f5e6bd9b7183ab2a615908aceaf8e5e54204f52" => :mountain_lion
  end

  head do
    url "https://github.com/FFMS/ffms2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    # For Mountain Lion
    ENV.libcxx

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-avresample
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    # download small sample and check that the index was created
    resource("videosample").stage do
      system "ffmsindex", "lm20.avi"
      assert File.exist? "lm20.avi.ffindex"
    end
  end
end
