class Metar < Formula
  desc "Get METAR aviation weather reports on your command-line"
  homepage "https://github.com/vsinha/METAR"
  url "https://github.com/vsinha/METAR/archive/1.0.0.tar.gz"
  sha256 "bcec28654b73bbfcb7115462b93f64b9f4eb7ec7208c63d60e92f16d4dcf7423"

  def install
    bin.install "metar"
  end

  test do
    system "#{bin}/metar"
  end
end
