require "formula"

class PamYubico < Formula
  homepage "http://opensource.yubico.com/yubico-pam/"
  url "https://github.com/Yubico/yubico-pam/archive/2.15.tar.gz"
  sha1 "a0a7df66ae95d2355a41399e61023f9ea600c3b1"

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
