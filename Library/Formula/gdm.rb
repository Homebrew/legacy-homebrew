require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.3.tar.gz"
  sha256 "e545378699a557e6dffedb1c25f54ea4f1bf93c1c825ec693f81f391569c8529"

  bottle do
    cellar :any_skip_relocation
    sha256 "aba6293bdbb344d907821d55946f322c265f86fbc30ea09a6e013f37085371dc" => :el_capitan
    sha256 "64659933d888ce34a9e84376c2d941c65dd4a369c07a1f9bb28a821e2512a8ab" => :yosemite
    sha256 "86f810b913f609316854d7254e55b9969bc058fb5fa6dc9fb88b05d2434be726" => :mavericks
  end

  depends_on "go"

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
    :revision => "6f233b96dfbc53e33b302e31b88814cf74697ff6"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/sparrc"
    ln_sf buildpath, buildpath/"src/github.com/sparrc/gdm"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/sparrc/gdm" do
      system "go", "build", "-o", bin/"gdm",
             "-ldflags", "-X main.Version=#{version}"
    end
  end

  test do
    ENV["GOPATH"] = testpath
    assert_match "#{version}", shell_output("#{bin}/gdm version")
    assert_match "#{testpath}", shell_output("gdm save")
    system "gdm", "restore"
  end
end
