require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'http://webp.googlecode.com/files/libwebp-0.2.0.tar.gz'
  sha1 'ac169a819cb4e7ece8d50d3f9f2608dac87a90e2'

  depends_on :libpng
  depends_on 'jpeg' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/cwebp", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
  end
end
