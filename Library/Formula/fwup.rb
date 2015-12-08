class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/archive/v0.4.2.tar.gz"
  sha256 "1c444d52dded8f69de127f71346d53ebee16fae7cfde23f6a324336b2b6940bb"
  revision 1

  bottle do
    cellar :any
    sha256 "8e8a68239a00402325417a0c1329a3e53fc557c0c3d5a2e9705f9623d11d091f" => :el_capitan
    sha256 "9598de8c0a255137ff86e18404c5f92ff376fa46a62842b9eea70e3c2dc2e72e" => :yosemite
    sha256 "10241696fa264411ac99db61411ca32a6c9337e9ccd0561975e485ab244c64c1" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

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
