require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'http://webp.googlecode.com/files/libwebp-0.2.1.tar.gz'
  sha1 'fd0042dffd67786f5048f6306466c45174e39562'

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
