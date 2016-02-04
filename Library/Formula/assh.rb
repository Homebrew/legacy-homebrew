require "language/go"

class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.2.0.tar.gz"
  sha256 "8a71969df06e8db0bd4b06cf928780e45e22cf5f131f06aec43cccd955ee2ead"

  head "https://github.com/moul/advanced-ssh-config.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]

    system "go", "build", "-o", "#{bin}/assh", "-v", "github.com/moul/advanced-ssh-config/cmd/assh/"
  end

  test do
    output = shell_output(bin/"assh --version")
    assert_match "assh version 2", output
  end
end
