class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://yubico.github.io/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.16.3.tar.gz"
  sha256 "38a9558053f68c488fa5737200fa5d6c7503944374ad298c8fa33d596f7fa055"

  bottle do
    cellar :any
    sha256 "7e1180b85e831a4309d985d932aa6a895580f72896c172cef3bae2ea81b89f50" => :yosemite
    sha256 "3f1a90e150cb8bb4e52c8d0b25146565fafe3f32126aaa54c1ac20b4dcad3462" => :mavericks
    sha256 "0ee8e56414b46570291feb4802e244695ba187e1dc8906a2d8acf66c938e90ab" => :mountain_lion
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
