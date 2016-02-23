class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.17.3.tar.gz"
  sha256 "482fc3984fc659c801cfc51313268f248507094ed5224f4394cfd66e23af9c0c"

  bottle do
    cellar :any
    sha256 "d82d6369ed404952c6bd65f59ce69c8c7845ba10d2fe5d92bc54ce364abe31fd" => :el_capitan
    sha256 "7bf1c600247c45af931788d8ef68c3967ae242799e0ad61d23599b1fa6204cad" => :yosemite
    sha256 "f1d7bd04356595e6de60d16bdb09e8bb9bb70506fad8061f9178a356fd2f47b2" => :mavericks
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
