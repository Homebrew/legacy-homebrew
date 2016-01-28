class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v52.tar.gz"
  sha256 "37a526b6af329b05f81ec92b72488b2a4cdc8457aa9ac5643ca20c28844e277d"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e20c51fff6afb5e353869b847098b7e6c1fff754872ff967c34a442918f8402" => :el_capitan
    sha256 "58770f590f8af2098a91deba8a045faa93d57135782e73bcc066ab7808b4ad71" => :yosemite
    sha256 "a3790a10b9052d75c6a9fc0502cdd877ca5cd8d103bb346817489b4fbdce276e" => :mavericks
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
