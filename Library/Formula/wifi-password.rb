class WifiPassword < Formula
  desc "Show the current WiFi network password"
  homepage "https://github.com/rauchg/wifi-password"
  url "https://github.com/rauchg/wifi-password/archive/0.1.0.tar.gz"
  sha1 "041331abc6667d736093da43fd2afdb5bbfc57d5"

  def install
    bin.install "wifi-password.sh" => "wifi-password"
  end

  test do
    system "#{bin}/wifi-password", "--version"
  end
end
