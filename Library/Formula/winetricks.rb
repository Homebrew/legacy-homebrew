class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20150826.tar.gz"
  sha256 "9b7401aebe61656f0a75ab04261a1531967d93b762b650a98af5928961e98ab0"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"
  depends_on "wine"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
