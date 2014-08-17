require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'https://webp.googlecode.com/files/libwebp-0.4.0.tar.gz'
  sha1 '326c4b6787a01e5e32a9b30bae76442d18d2d1b6'
  head 'https://chromium.googlesource.com/webm/libwebp', :branch => 'master'

  bottle do
    cellar :any
    sha1 "917f008789d42387a236bf2f91c7c32e35ac8726" => :mavericks
    sha1 "8585b90461bfee0e0a79a82a0ea939ad5aa9e64d" => :mountain_lion
    sha1 "3faef81ac165696eaf3631a8ce27c5a5f5ceb83b" => :lion
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
    test_png = HOMEBREW_LIBRARY/"Homebrew/test/fixtures/test.png"
    system "#{bin}/cwebp", test_png, "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
  end
end
