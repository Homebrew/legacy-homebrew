class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v57.tar.gz"
  sha256 "abc7b482690fdd76ed35c3e1a297090668dac446ebc605a75a0114203cb63e72"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d622b23cc04d4a719c71256fa69f1ed4bca043a8bba9e43654d8de1d748ee6" => :el_capitan
    sha256 "6d59cb9af8ae1fd4c37712882af7e237182aada345be0ab94a3b0613d9fe6d24" => :yosemite
    sha256 "a6785e1bbd5991ce27dcdb4d14cff13a7c13e07b3b86c31ed7c3fbe93f3aafb8" => :mavericks
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
