class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v29.tar.gz"
  sha256 "ca896c220f2995a50a5d9e63df929fa393c3cd1de9722210b5ef3684981bed2a"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9d4a7386b86fca27e1762859bdad5e90883ddc038ffd3eb82c631055381f3f" => :el_capitan
    sha256 "d70a3a2b143f7440f201829562748f976119fc8517859deac109b24739cbf0bc" => :yosemite
    sha256 "da476787515094caf65b3f13cfc7a3c4058e9291607243c005fce3c6946cd4fc" => :mavericks
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
