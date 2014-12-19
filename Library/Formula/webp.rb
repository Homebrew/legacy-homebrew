require 'formula'

class Webp < Formula
  homepage "https://developers.google.com/speed/webp/"
  url 'http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz'
  sha256 '14d825d7c2ef7d49621bcb6b83466be455585e671ae0a2ebc1f2e07775a1722d'

  bottle do
    cellar :any
    sha1 "5eb5c1021f826ddb6fc224a24c25c42e031d7662" => :yosemite
    sha1 "4a937acc7cfdec599bd78809447bd03eb2bf6fc9" => :mavericks
    sha1 "3a1b012465710145c7daf74251bfe99bfd477ec4" => :mountain_lion
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
