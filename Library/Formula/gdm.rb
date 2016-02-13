require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.2.tar.gz"
  sha256 "7477c98e446295be32b1666b0752dcd9ab4447d2fd9561952f0c589752282d7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a977218e8e6b0b7419b2b5fcb1ebd6977f4e0a56991258a442e4e0bc82239c76" => :el_capitan
    sha256 "0c49f92e76d91f2f303befa1467599a7f93bfbf03bc7cc194f178ca8222e4b90" => :yosemite
    sha256 "88716d7409276f28ccf4f3bdd30e16e0e511a496f1cd75fc9ab297fe5584e270" => :mavericks
  end

  depends_on "go"

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
    :revision => "608d57b3ae930138a65e85b64edf2ba1b3450b06"
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
