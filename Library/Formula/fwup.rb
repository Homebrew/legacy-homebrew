class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/archive/v0.4.2.tar.gz"
  sha256 "1c444d52dded8f69de127f71346d53ebee16fae7cfde23f6a324336b2b6940bb"

  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
