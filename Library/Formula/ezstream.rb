class Ezstream < Formula
  homepage "http://www.icecast.org/ezstream.php"
  url "http://downloads.xiph.org/releases/ezstream/ezstream-0.6.0.tar.gz"
  sha256 "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9"

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libshout"
  depends_on "theora"
  depends_on "speex"
  depends_on "libogg"

  resource "stream" do
    url "http://dir.xiph.org/listen/5200/listen.m3u"
    sha256 "ff44097742f92b73a63332760585217eb357389eea7f92465ff769043d365aea"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("stream").stage do
      stream = fork do
        system bin/"ezstream", "-s", "listen.m3u"
      end
      sleep 5
      Process.kill("TERM", stream)
    end
  end
end
