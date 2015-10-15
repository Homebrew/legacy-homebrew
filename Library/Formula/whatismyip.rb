
class Whatismyip < Formula
  desc "Simple tool for discovering your public ip address"
  homepage "https://github.com/kellyp/whatismyip"
  url "https://github.com/kellyp/whatismyip/archive/v1.0.tar.gz"
  version "1.0"
  sha256 "492a0f2e6a72254f54cc59707381df04d2fc2542ae5df60dfbd0ba929aa51812"

  def install
    bin.install Dir["whatismyip"]
  end

  def caveats; <<-EOS.undent
    You can get your public internet address with the command:

      $ whatismyip
      73.25.55.133

    EOS
  end

  test do
    system "#{bin}/whatismyip"
  end
end
