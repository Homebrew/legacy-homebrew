require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/v1.0.tar.gz"
  sha256 "e0dbec8deed27af3ff4cb16782bc38a4fd8eeb0db8e024b3083a00d36f877cab"

  depends_on "go"

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
    :revision => "b48dc8da98ae78c3d11f220e7d327304c84e623a"
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
