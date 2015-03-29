class FonFlashCli < Formula
  homepage "http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "http://www.gargoyle-router.com/downloads/src/gargoyle_1.5.11-src.tar.gz"
  version "1.5.11"
  sha256 "daf3b3a10e48dbed10f1314a14f528a79f180ee3b724d7e1d4cb83304bd9946d"

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
