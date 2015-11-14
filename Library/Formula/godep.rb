class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v28.tar.gz"
  sha256 "cf5a63943061add896d349704ccd8b4d9f4341257d028e63e53fbf7a81b366aa"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48aa501daffc0931ef6b111b706a309b40f5de59060b08d5427bd4ad43ace59b" => :el_capitan
    sha256 "83410b9f432581d0db443773875f5180e32f5c039aed651d404603813b79411c" => :yosemite
    sha256 "d56277d4da05352acb6f0ed64f3bcc5cf27722e344e305a7e3cac20d9447c599" => :mavericks
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
