class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.8.0-src.tar.gz"
  version "1.8.0"
  sha256 "89493cfedbe38800121fbe5e281e0542df4026f76de242ef664120649900772a"

  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f6a248a19a645ea96026056c282c0a50487e0157e7524dcb132e5d68819036b" => :el_capitan
    sha256 "81a834863603744f16c18b9aa5ea35c2a2d94cab29ec813ebbb26f036a7cbe05" => :yosemite
    sha256 "6d9553416c6ee3357c1c160b2f77bcea950a9c326c659011c11ea039200d3384" => :mavericks
    sha256 "0e2e7ff173495f9e9d908be176ad95589637da5f4849ce4702ee82ee410f3308" => :mountain_lion
  end

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
