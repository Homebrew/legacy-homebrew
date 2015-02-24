class Winetricks < Formula
  homepage "https://code.google.com/p/winetricks/"
  url "https://code.google.com/p/winetricks.git", :revision => "fa9e42955dbdf780240dedf9057295264fddd98f"
  version "20150114"
  sha1 "fa9e42955dbdf780240dedf9057295264fddd98f"

  head "https://code.google.com/p/winetricks.git"

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"
  depends_on "wine"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system  "#{bin}/winetricks", "dlls", "list"
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end
end
