class PamYubico < Formula
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://github.com/Yubico/yubico-pam/archive/2.19.tar.gz"
  sha256 "64900586555adadd515189a6f58aaf3b12c5fb0012d030a94ce4d7c1747c702c"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "asciidoc" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV.universal_binary if build.universal?

    ENV["XML_CATALOG_FILES"] = HOMEBREW_PREFIX/"etc/xml/catalog"

    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}",
                          "--with-libykclient-prefix=#{Formula["ykclient"].opt_prefix}"
    system "make", "install"
  end

  test do
    # Not much more to test without an actual yubikey device.
    system "#{bin}/ykpamcfg", "-V"
  end
end
