require "formula"

class PamYubico < Formula
  homepage "http://opensource.yubico.com/yubico-pam/"
  url "https://github.com/Yubico/yubico-pam/archive/2.16.tar.gz"
  sha1 "e0724a433a2c84b303fdb28efdda023349a27193"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}",
                          "--with-libykclient-prefix=#{Formula["ykclient"].opt_prefix}"
    system "make install"
  end
end
