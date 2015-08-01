class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.20.tar.gz"
  sha256 "c7d880172756c253f2c5673044dabf03c19890dcfe64da5104ee9f42a1a573a0"

  bottle do
    cellar :any
    sha256 "04726b5c91736f834e59fab880bc5dbe674e1fd2a12eaeb58f5ad7f3abfe3b85" => :yosemite
    sha256 "5e0606d2c83e377963dde83af58114e6c08d50e6240824671263939b41d1e664" => :mavericks
    sha256 "a487b80dd08906279aa6b80ffa33162f7ec1520ec4a862f7e9eae25b56d5488e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"

  resource "videosample" do
    url "http://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  # needed for the test section to exit cleanly, next version won't need it
  patch do
    url "https://github.com/FFMS/ffms2/commit/2c59b6a420bc8cf35fc8552a37a63d7d6e1ef424.diff"
    sha256 "b43bd100579c088b13f6dba992c728bb831f0813b12f5cb4053b9249c2fbfa92"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-avresample",
                          "--prefix=#{prefix}"
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
