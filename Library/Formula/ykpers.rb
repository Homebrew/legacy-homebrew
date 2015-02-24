class Ykpers < Formula
  homepage "http://yubico.github.io/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.16.2.tar.gz"
  sha1 "cb8ae32eb2c2eca6c2c156e8f26a3576cb839c52"

  bottle do
    cellar :any
    sha1 "0dada94f9df986ada86796f85b17b85732eb05c7" => :yosemite
    sha1 "2bfc7c38f9ddb776b843418901566c9808f96660" => :mavericks
    sha1 "8249521d7f21a8749160730d6cecf35837403279" => :mountain_lion
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
end
