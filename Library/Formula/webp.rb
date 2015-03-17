class Webp < Formula
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.4.3.tar.gz"
  sha256 "efbe0d58fda936f2ed99d0b837ed7087d064d6838931f282c4618d2a3f7390c4"

  bottle do
    cellar :any
    sha1 "5eb5c1021f826ddb6fc224a24c25c42e031d7662" => :yosemite
    sha1 "4a937acc7cfdec599bd78809447bd03eb2bf6fc9" => :mavericks
    sha1 "3a1b012465710145c7daf74251bfe99bfd477ec4" => :mountain_lion
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
