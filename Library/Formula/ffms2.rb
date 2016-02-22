class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.22.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/f/ffms2/ffms2_2.22.orig.tar.gz"
  sha256 "7c5202fa2e49186fb3bb815e5b12ca71f05ec09cb707ffd9465852e21a06fdad"
  revision 1

  bottle do
    cellar :any
    sha256 "265169583ade2f063b8fd1cb86533652bf61629f48b0b7960afe7bccdc9686f2" => :el_capitan
    sha256 "551433ae260b3476b395cd5b0ea867cfbdb24eb522b728548acfb584a25cd664" => :yosemite
    sha256 "d739243fd8e0a29949eb70dccb0de80d48876c501d6a74e3b0c2e0c4b9110fd0" => :mavericks
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
