class WifiPassword < Formula
  desc "Show the current WiFi network password"
  homepage "https://github.com/rauchg/wifi-password"
  url "https://github.com/rauchg/wifi-password/archive/0.1.0.tar.gz"
  sha256 "6af6a34a579063eb21c067f10b7c2eb5995995eceb70e6a1f571dc78d4f3651b"

  bottle :unneeded

  def install
    bin.install "wifi-password.sh" => "wifi-password"
  end

  test do
    system "#{bin}/wifi-password", "--version"
  end
end
