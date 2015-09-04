class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.8.0-src.tar.gz"
  version "1.8.0"
  sha256 "89493cfedbe38800121fbe5e281e0542df4026f76de242ef664120649900772a"

  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any
    sha256 "da43411ae884484498b86415082f8da9dc40dddfd452298819654fcbfd87850c" => :yosemite
    sha256 "50429372e53a79b20a90d371f096be96ab3ef8d3887af9e546d50473683e26ca" => :mavericks
    sha256 "796d8314d21033b410f2ad366bc0cbae5c1ef69b86a16bb4cf2b9e096b182f3d" => :mountain_lion
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
