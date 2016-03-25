class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.6.0/fwup-0.6.0.tar.gz"
  sha256 "11d8d3a6e7464584b89d88571ee2d2dc1da758fe98525191e77982c60f35bcf3"

  bottle do
    cellar :any
    sha256 "b57b46b4de20e58ad04c8e161c238767322fedd80aaba6ec27efded4d6c69ef6" => :el_capitan
    sha256 "25dcd45f7f0e399504dc90e9640f3dd28fb7cccbe702eaa24b169e02ca596a9d" => :yosemite
    sha256 "cca8882d53b591b5b0555f5830cc3702d2bb878de44be271d8f566ddd8400b81" => :mavericks
  end

  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
