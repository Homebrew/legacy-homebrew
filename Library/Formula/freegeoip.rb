class Freegeoip < Formula
  homepage "https://github.com/fiorix/freegeoip/"
  url "https://github.com/fiorix/freegeoip/releases/download/v3.0.4/freegeoip-3.0.4-darwin-amd64.tar.gz"
  sha1 "b13b57ceb6f49be28459fc8c8fd04de78985a8df"

  depends_on "go" => :build

  def install
    bin.install "freegeoip"
    libexec.install "public"
  end

  test do
    assert_equal "freegeoip v3.0.4\n", shell_output("#{bin}/freegeoip --version")
  end
end
