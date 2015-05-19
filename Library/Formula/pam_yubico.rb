class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://github.com/Yubico/yubico-pam/archive/2.19.tar.gz"
  sha256 "64900586555adadd515189a6f58aaf3b12c5fb0012d030a94ce4d7c1747c702c"

  bottle do
    cellar :any
    sha256 "039dd7efee01ef4ee45e2882095090f02b46d3f79d426b3c801b831e5910ac86" => :yosemite
    sha256 "3bcc041522646e14dd83f9ec312ef7ca363519d4b1de62b58acd56e130fffabe" => :mavericks
    sha256 "5098b5a0f4f55b777b2aa469e7f85e1512ebbdd06c9e508b3c2dc4c269be132d" => :mountain_lion
  end

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
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

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
