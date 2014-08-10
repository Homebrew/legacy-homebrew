class Ffms2 < Formula
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.20.tar.gz"
  sha256 "c7d880172756c253f2c5673044dabf03c19890dcfe64da5104ee9f42a1a573a0"

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
