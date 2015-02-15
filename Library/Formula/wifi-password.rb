class WifiPassword < Formula
  homepage "https://github.com/rauchg/wifi-password"
  url "https://github.com/rauchg/wifi-password/archive/0.0.1.tar.gz"
  version "0.0.1"
  sha1 "7f92794a3a04762009a0c4525cbf2aa851002289"

  def install
    bin.install "wifi-password.sh" => "wifi-password"
  end

  def test
    system "#{bin}/wifi-password", "--version"
  end
end
