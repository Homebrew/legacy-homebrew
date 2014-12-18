class Asciinema < Formula
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema-cli/archive/v0.9.9.tar.gz"
  sha1 "155c19366ffb3347e97026e9ab8006c16d2a52c6"

  depends_on "go" => :build
  depends_on "hg" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath

    system "go", "get", "-d", "-v", "./..."
    system "go", "build", "-o", "asciinema"
    bin.install "asciinema"
  end
end
