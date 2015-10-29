class NicovideoDl < Formula
  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.jp/projects/nicovideo-dl/"
  url "http://dl.osdn.jp/nicovideo-dl/56304/nicovideo-dl-0.0.20120212.tar.gz"
  sha256 "a50e9d5c9c291e1e10e5fc3ad27d528b49c9671bdd63e36fb2f49d70b54b89d8"

  bottle :unneeded

  def install
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
