class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.21.tar.gz"
  sha256 "c7cffa84643905f887bee0dff743e2d5873434ccc371c6065317e853ad9c7e61"

  bottle do
    cellar :any
    sha256 "cd9894a74a2c45b2ef420834dde59db3dd959eb8ad06ef29f10d797078af8f38" => :el_capitan
    sha256 "38d9993738d6a8b73dd2da54ab1d0fd7449274eda96529fc4293b1a1ac5ac49c" => :yosemite
    sha256 "99932983f3459707e49c979fb27e1e63f552bbda28472859b0312d568b0b8fc3" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV.universal_binary if build.universal?
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

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
