require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.3.0.tar.gz"
  sha256 "b02ed007f831b9ffd79be0b670c6c1bfa59a87ba87ac54dea48005cfb305f5c7"

  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any
    sha256 "cf1bc6ff8c7e6f2b2d6d261b4a814b0be2c39c78391a1c0aef0dcc921290a0e3" => :yosemite
    sha256 "9348df3ab4714c633f3f968ae49a69d730c8c472fa8688063c2442c1535b59de" => :mavericks
    sha256 "6daa7b39dbbbab7f520760285e3ea6a052bb5828e567fa2387b2fd2cd4e60880" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p buildpath/"src/github.com/scaleway"
    ln_s buildpath, buildpath/"src/github.com/scaleway/scaleway-cli"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "scw", "."
    bin.install "scw"

    bash_completion.install "contrib/completion/bash/scw"
    zsh_completion.install "contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
