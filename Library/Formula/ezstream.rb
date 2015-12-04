class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "http://www.icecast.org/ezstream.php"
  url "http://downloads.xiph.org/releases/ezstream/ezstream-0.6.0.tar.gz"
  sha256 "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9"

  bottle do
    sha256 "c44691fda53a244f191f6e42f58f9fe3fd199854012f1ddd12336960b636cd8a" => :yosemite
    sha256 "3c561b55511c8e4592d43e347de51696aff668981662fda94bec00eca1af8c40" => :mavericks
    sha256 "21932b7cba0c5a734d9dca1e9c418be55f891a76a846737fc90f1f90ccb802ec" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libshout"
  depends_on "theora"
  depends_on "speex"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write "#{test_fixtures("test.mp3")}"
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
