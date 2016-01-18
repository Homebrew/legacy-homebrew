require "language/go"

class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.012.tar.gz"
  sha256 "804861f2a7a36eef53a7310e52627e790fa9de66acf8565f697089389d2709a0"
  revision 1

  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fcd5e53a5daeebc80de7db5007493609d441894a92eaeca5fee7d1eab60577d" => :el_capitan
    sha256 "30517310990db7dfc62be36b1142e8094a1d80f49e0d52cf32e22091e03fb44b" => :yosemite
    sha256 "f04e476d5ece8703aef3e9db7d12bc7b1825222e70060ee20b4980b74f63e52e" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/t3rm1n4l/go-humanize" do
    url "https://github.com/t3rm1n4l/go-humanize.git",
    :revision => "e7ed15be05eb554fbaa83ac9b335556d6390fb9f"
  end

  go_resource "github.com/t3rm1n4l/go-mega" do
    url "https://github.com/t3rm1n4l/go-mega.git",
    :revision => "551abb8f1c87053be3f24282d198a6614c0ca14f"
  end

  go_resource "github.com/t3rm1n4l/megacmd" do
    url "https://github.com/t3rm1n4l/megacmd.git",
    :revision => "d7f3f3a2427cc52b71cad90b26889e2a33fc3565"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"megacmd"
  end

  test do
    system bin/"megacmd", "--version"
  end
end
