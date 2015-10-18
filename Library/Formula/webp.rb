class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.4.3.tar.gz"
  sha256 "efbe0d58fda936f2ed99d0b837ed7087d064d6838931f282c4618d2a3f7390c4"

  bottle do
    cellar :any
    sha256 "80b70138639a6f7e0826da6b8f757ca7b5ea08f34aa2f700879ab6a6f13fc805" => :el_capitan
    sha256 "5aaf06ba6c36b7877b19629f704918708d32d2a5a9b3e100b7fc2f033223e0cb" => :yosemite
    sha256 "3a44d990fd058d594b46a5d24b579e0f5da10c1a2779e992a980c6bd946be41f" => :mavericks
    sha256 "a96249caa1541d335ab594fdd0af221109be00baa94d82429048deb56ed88008" => :mountain_lion
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    system "./autogen.sh" if build.head?

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
