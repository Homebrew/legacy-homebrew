class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.4.4.tar.gz"
  sha256 "c65d34edb57338e331ba4d622227a2b3179444cfca17d02c34f1ead63f603e86"

  bottle do
    cellar :any
    sha256 "6b68cdb4ad6b808a6010100f4b1bd3a0aae25bff1f1870d776b73455d6416bc5" => :el_capitan
    sha256 "14aabf2823e0d5a44f1761d43a7cb282e3886061acf4de628e014a4d246fc8e1" => :yosemite
    sha256 "30c33dcdb953dbe48224104d4788b12e090bfb9cedeeafa5e92b66d54f842341" => :mavericks
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
