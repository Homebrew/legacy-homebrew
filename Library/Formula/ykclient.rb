class Ykclient < Formula
  homepage "https://yubico.github.io/yubico-c-client/"
  url "https://yubico.github.io/yubico-c-client/releases/ykclient-2.14.tar.gz"
  sha256 "bd7ddaa1d88ec7be323738cabdf58ff99cb6d6cd3fe937c69b52fa9b3764d362"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ykclient", "--version"
  end
end
