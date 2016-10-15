class Websocketd < Formula
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.2.10.tar.gz"
  sha1 "4387c39aaf77e1bb5b6991358f02611a7b5dac1e"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p "src/github.com/joewalnes"
    ln_s "../../../", "src/github.com/joewalnes/websocketd"

    system "go", "get", "./src/github.com/joewalnes/websocketd"
    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", "websocketd"

    bin.install "websocketd"
    man1.install "release/websocketd.man" => "websocketd.1"
  end

  test do
    assert_equal "websocketd #{version}\n", shell_output("#{bin}/websocketd --version", 2)
  end
end
