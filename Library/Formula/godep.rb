class Godep < Formula
  desc "dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v60.tar.gz"
  sha256 "a9dafa87d571dfc817e9e101b20a856c534951d52059cf5af1be599d88b7e6d6"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a98cc7975cba797f43efc0938742e8d0c2304e8965ae870183415547752b1e4" => :el_capitan
    sha256 "f294ee34bdb28ae397f00f75539dc59745b7ad32da50ca61d7f36fa27afe2238" => :yosemite
    sha256 "ef53ad3a373f5e3eac92f2b695640a9633266681f8891278ce135d47d345de9e" => :mavericks
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
