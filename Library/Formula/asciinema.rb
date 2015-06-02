require "language/go"

class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.1.0.tar.gz"
  sha256 "2f03549620534341e883b630c6947c3b4ecd234105ec1d7aa98393a00f0845e8"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any
    sha256 "58318ae8f0df8ec4ef5f08106e2c3e0c9157b030cb19e170e2e6fa9942c607a0" => :yosemite
    sha256 "983b9641df3c5ef0543b197368dbc272f57a230d3ea2541ababf4de7fb4c27fb" => :mavericks
    sha256 "69fcc08cfe0f382e26a5441a19bf1f6b9a19ccacb6c70b8044d1b8a5e96219fd" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
      :revision => "5cf931ef8f76dccd0910001d74a58a7fca84a83d"
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

    system "go", "build", "-o", bin/"asciinema"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
