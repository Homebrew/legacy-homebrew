class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v53.tar.gz"
  sha256 "e73cfa0390af84c4ffa7a43242af2ecc0213819a9a3eebd4a3b335f683c02cd8"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cdfff5233a4b7f53eb36d1dd0ca5b8fdc0dc5aac8f3cf5353d650eb5554a484" => :el_capitan
    sha256 "70378c2c9d4e05a26532fcf5c7967a44efe516c0731d9e89ee15c6a2aa7f4192" => :yosemite
    sha256 "5cbb360c3e8a4e0b83572a9f87b968b04a980f63405f766e002e9457fbbf5756" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/tools/"
    ln_sf buildpath, buildpath/"src/github.com/tools/godep"

    cd "src/github.com/tools/godep" do
      system "go", "build", "-o", bin/"godep"
    end
  end

  test do
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir "Godeps"
    (testpath/"Godeps/Geodeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.4.2",
        "Deps": []
      }
    EOS
    system bin/"godep", "path"
  end
end
