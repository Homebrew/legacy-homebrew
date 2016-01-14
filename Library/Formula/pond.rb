require "language/go"

class Pond < Formula
  desc "Forward secure, asynchronous messaging"
  homepage "https://pond.imperialviolet.org/"
  url "https://github.com/agl/pond/archive/v0.1.1.tar.gz"
  sha256 "f66c625b0d7e3fe8c125fe9401a5f67ec75af3e8dca47e18fba6696a99705b21"
  revision 1

  head "https://github.com/agl/pond.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ec6e265c8d717d63815777fc98f287df5c0a927b72120e2f359c533c60d5111b" => :el_capitan
    sha256 "a5babef84837c25b20c716112aa78f2112835636e1ba5c7d881df4bbaad70f55" => :yosemite
    sha256 "2bd9a3094f61ca9e541085c8f6b926788214a0d21e51ef91786a72691612c7bc" => :mavericks
  end

  option "with-gui", "Additionally build the gtk+3 GUI of pond"

  depends_on "go" => :build
  depends_on "tor" => :recommended

  if build.with? "gui"
    depends_on "gtk+3"
    depends_on "gtkspell3"
  end

  go_resource "github.com/agl/ed25519" do
    url "https://github.com/agl/ed25519.git",
    :revision => "278e1ec8e8a6e017cd07577924d6766039146ced"
  end

  go_resource "github.com/agl/pond" do
    url "https://github.com/agl/pond.git",
    :revision => "bce6e0dc61803c23699c749e29a83f81da3c41b2"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
    :revision => "68415e7123da32b07eab49c96d2c4d6158360e9b"
  end

  go_resource "github.com/agl/go-gtk" do
    url "https://github.com/agl/go-gtk.git",
    :revision => "91c1edb38c241d73129e6b098ca1c9fa83abfc15"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "7b85b097bf7527677d54d3220065e966a0e3b613"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "72b0708b72ac7a531f8e89f370e6214aad23ee2e"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    if build.with? "gui"
      system "go", "build", "-o", bin/"pond", "./client"
    else
      system "go", "build", "-tags", "nogui", "-o", bin/"pond", "./client"
    end
  end

  def caveats
    s = ""

    if build.without? "tor"
      s += <<-EOS.undent
        Pond requires Tor to be installed and running for usage. If you do not
        wish to use Homebrew's Tor you can install and run the Tor Browser Bundle.

        Pond will refuse to load successfully without Tor.
      EOS
    end

    s
  end

  test do
    # Pond requires Tor to be running and configured a certain way.
    # Without that, this is a basic check to verify the command runs.
    assert_match %r{Usage of #{bin}/pond}, shell_output("#{bin}/pond -cli -h 2>&1", 2)
  end
end
