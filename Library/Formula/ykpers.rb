class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.17.3.tar.gz"
  sha256 "482fc3984fc659c801cfc51313268f248507094ed5224f4394cfd66e23af9c0c"

  bottle do
    cellar :any
    sha256 "61d466fe3b295a6b4a6a1642dc8f1a393e28a6e9705260cf4107e8ad62a8bcab" => :el_capitan
    sha256 "b3b65497b0b754c40a4b72ba607f9cc8149400dc2b4a89debc9a752f8add51a9" => :yosemite
    sha256 "708fcea4a38578c8dabe046c07d8705bb8d1874c8b389c46e2edd6bc4f8b1d5c" => :mavericks
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
    assert_match "1.17.3", shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
