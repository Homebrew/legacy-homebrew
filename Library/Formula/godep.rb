class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v53.tar.gz"
  sha256 "e73cfa0390af84c4ffa7a43242af2ecc0213819a9a3eebd4a3b335f683c02cd8"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "409ac8aa9b0f4bf0d3f4a9faf39f34c5e3a1063c4ce04db167f61bd7f4ec54be" => :el_capitan
    sha256 "33c558efd4a57d673990f1f51aa44c22ece4a9edc1f53d2c34e4179ec941434a" => :yosemite
    sha256 "3c317d7a74cd5a6446a1c2bbba024e0cb0d2800fe86f9814d07a199c0fcd1aa2" => :mavericks
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
