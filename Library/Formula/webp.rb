require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'https://webp.googlecode.com/files/libwebp-0.3.1.tar.gz'
  sha1 '52e3d2b6c0b80319baa33b8ebed89618769d9dd8'

  depends_on :libpng
  depends_on 'jpeg' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
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
