class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs."
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.2.0.tar.gz"
  sha256 "af180846f96204e88a78bada14781e8441ab02a7d2421e66f8d4fbcb2d82b21d"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "build"
    bin.install "ssllabs-scan"
  end

  test do
    system "#{bin}/ssllabs-scan", "-version"
  end
end
