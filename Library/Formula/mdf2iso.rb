class Mdf2iso < Formula
  desc "Tool to convert MDF (Alcohol 120% images) images to ISO images"
  homepage "https://packages.debian.org/sid/mdf2iso"
  url "https://mirrors.kernel.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  sha256 "906f0583cb3d36c4d862da23837eebaaaa74033c6b0b6961f2475b946a71feb7"

  bottle do
    cellar :any
    sha256 "ae592a8d5662b2ae962603addaf55b521f3968f5d7745f761a9b90f7b5cdabf6" => :yosemite
    sha256 "e9af5cc191566bcf09cf9f1d22532c2971b0d66518a4b7b8c1a613f151536791" => :mavericks
    sha256 "8a82cbf7a260bb216412f27dc67f75ea047472b5ce01526ee5246466574a27c3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mdf2iso --help")
  end
end
