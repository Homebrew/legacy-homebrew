class WifiPassword < Formula
  homepage "https://github.com/rauchg/wifi-password"
  url "https://github.com/rauchg/wifi-password/raw/0.1.0/wifi-password.sh"
  sha1 "3b4b827b8fdb6f40080aae9e97cec100fcae37db"

  head "https://github.com/rauchg/wifi-password.git"

  def install
    bin.install "wifi-password.sh" => "wifi-password"
  end
end
