class FonFlashCli < Formula
  homepage "http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "http://www.gargoyle-router.com/downloads/src/gargoyle_1.7.1-src.tar.gz"
  sha256 "96089b8ce40d7fe821375173f9f2060530e78fa50e9029e932bc35bc2dd2c300"
  version "1.7.1"

  head "https://github.com/ericpaulbishop/gargoyle.git"

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
