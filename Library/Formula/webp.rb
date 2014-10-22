require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'https://webp.googlecode.com/files/libwebp-0.4.0.tar.gz'
  sha1 '326c4b6787a01e5e32a9b30bae76442d18d2d1b6'
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
