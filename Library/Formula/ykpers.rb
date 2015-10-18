class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://yubico.github.io/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.17.1.tar.gz"
  sha256 "556baec2bbc94bae01293e64dc3873d68f880119ea5c3772737e4f3dc44f69c4"

  bottle do
    cellar :any
    sha256 "c577358088046af6f85ed74ef45c59af5ca11b96b19a03e477a7b9e8499f3523" => :el_capitan
    sha256 "523818ae289b6ed8fa96167ea031db62967593e8d1f3920da393415b941d0100" => :yosemite
    sha256 "cd0fb40488fb33703e8f3f64eaa4a7f83867ace0981a867285cdc265a35d0860" => :mavericks
    sha256 "1610b5e3da6e050ac855de882316a2f2be5761e05f8261fb1e779b7cb0b8d681" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "json-c" => :recommended

  def install
    ENV.universal_binary if build.universal?
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/ykinfo", "-V"
  end
end
