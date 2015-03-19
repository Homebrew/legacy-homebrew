require "language/go"

class Asciinema < Formula
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.0.0.tar.gz"
  sha1 "8e9862309a5bc1723cb27a40a412401ed05e4586"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any
    sha256 "5d87618afe5b7b3decee25d5571f26ef836588250254dfab39d5d77f9100410b" => :yosemite
    sha256 "9fe846d26e9dd6b2b021a1c326d684015091351ba8b4c6a0918a229f62542383" => :mavericks
    sha256 "27bde1b4865ced34f9e96b8b9aea5fb6cc4a30dee53e6f5ed1a02a3245de0fa9" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
      :revision => "67e2db24c831afa6c64fc17b4a143390674365ef"
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/",
      :revision => "aa2644fe4aa5", :using => :hg
  end

  go_resource "code.google.com/p/gcfg" do
    url "https://code.google.com/p/gcfg/",
      :revision => "c2d3050044d05357eaf6c3547249ba57c5e235cb", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/asciinema"
    ln_s buildpath, buildpath/"src/github.com/asciinema/asciinema"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "asciinema"

    bin.install "asciinema"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
