class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v57.tar.gz"
  sha256 "abc7b482690fdd76ed35c3e1a297090668dac446ebc605a75a0114203cb63e72"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5836b613eb4ebc458ac64a6c92a328a515aaa9f0aa979b5dbee6b376afe5911" => :el_capitan
    sha256 "432dbdfe4affc55606826df47d4fec5b0fc9963b133f3ab9a12c75efd2b9433f" => :yosemite
    sha256 "b6bbee352b50dcf550a46b30318a7257b3f9b187c55b0ea25531ad4000962f77" => :mavericks
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
