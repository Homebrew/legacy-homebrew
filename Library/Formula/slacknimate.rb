class Slacknimate < Formula
  desc "text animation for Slack messages"
  homepage "https://github.com/mroth/slacknimate"
  url "https://github.com/mroth/slacknimate/archive/v1.0.1.tar.gz"
  sha256 "ddac6002edd57a334ce828e2662264598ea7d471757747cffd85ffdfedbb044b"
  head "https://github.com/mroth/slacknimate.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    pkgpath = buildpath/"src/github.com/mroth"
    pkgpath.install Dir["*"]
    cd pkgpath do
      system "make"
      bin.install "bin/slacknimate"
    end
  end

  test do
    system "#{bin}/slacknimate", "--version"
    system "#{bin}/slacknimate", "--help"
  end
end
