require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz'
  sha256 '14d825d7c2ef7d49621bcb6b83466be455585e671ae0a2ebc1f2e07775a1722d'
  head 'https://chromium.googlesource.com/webm/libwebp', :branch => 'master'

  bottle do
    cellar :any
    revision 1
    sha1 "7d66d85810e10b0ef49cc4bf2a7b7e36972abaa3" => :yosemite
    sha1 "873ca6cb0be71d93cc80f723dc263bd391c7a813" => :mavericks
    sha1 "5ce282b5a2b80918657603d5714144339280fc92" => :mountain_lion
  end

  revision 1

  option :universal

  depends_on 'libpng'
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional
  depends_on 'giflib' => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
  end
end
