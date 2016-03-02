require "language/go"

class Gdm < Formula
  desc "Go Dependency Manager (gdm)"
  homepage "https://github.com/sparrc/gdm"
  url "https://github.com/sparrc/gdm/archive/1.3.tar.gz"
  sha256 "e545378699a557e6dffedb1c25f54ea4f1bf93c1c825ec693f81f391569c8529"

  bottle do
    cellar :any_skip_relocation
    sha256 "374cbb6f58775ee4dc077aa08ab12b984e74d56cdd949ab00667766bc88c5631" => :el_capitan
    sha256 "4f9a0d3677a9f414a385e705b87a6e4a6773f822d932e88271f9d546d8c1fb55" => :yosemite
    sha256 "508ea36fab42e9ee3fde2c7e07add3567c7b7a7b786d098bfcfa432e07b17442" => :mavericks
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
