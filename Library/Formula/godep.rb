class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v44.tar.gz"
  sha256 "d81d9a16e0ea199b262274f5d9570e5b2eea1699f80754ae3a244f2b7808cf95"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52a5259bc63b82d4dc87718dedcabb26803e35527a0587892ce49c5c53f73a74" => :el_capitan
    sha256 "b12f3da1d113b68779396fbf103f3e0c8c859b46a2f2b0acba88fa8e09fde240" => :yosemite
    sha256 "8e7d3e1f009e0dc301afa79164b87d7bf65113037d03d269faa395838379045c" => :mavericks
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
