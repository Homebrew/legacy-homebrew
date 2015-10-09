class Kaifa < Formula
  desc "Command-line tool for kaifa.li"
  homepage "https://github.com/kaifali/cli"
  url "https://github.com/kaifali/cli/archive/v0.0.2.tar.gz"
  sha256 "60229eec2ca9e719285a4fdb482598a6b612fd1f9eccbec8266e30a7ebb80d49"

  head "https://github.com/kaifali/cli.git"

  depends_on "go" => :build
  depends_on "gpm" => :build

  def install
    puts buildpath

    ENV["GOPATH"] = buildpath

    system "gpm install"
    system "go build kaifa.go"
    bin.install "kaifa"
  end

  test do
    system "#{bin}/kaifa", "--version"
  end
end
