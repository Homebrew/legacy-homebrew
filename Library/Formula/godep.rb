class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v44.tar.gz"
  sha256 "d81d9a16e0ea199b262274f5d9570e5b2eea1699f80754ae3a244f2b7808cf95"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be7dbefca0162f2edf96e6e621f458239be1d8f56e32094d100bc942ea245763" => :el_capitan
    sha256 "de09d15aec13f3daca7a96cd2d0019352f0beba5408d3a2ef7274772020d7c5c" => :yosemite
    sha256 "40ba826efc0dc0c440c6cd7db7c168f025fb63a7866bf258dd4156bbec101bb2" => :mavericks
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
