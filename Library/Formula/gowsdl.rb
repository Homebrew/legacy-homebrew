require "language/go"

class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl/archive/v0.2.1.tar.gz"
  sha256 "d2c6ef8a6ee5b78d9753d4a4e6ffd06c23324a4eb9de0d778ab7fc50ea6b9902"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8ca657c1c298726fed20e337c289721f8f357bc68fda4e225b73b8197da7a28" => :el_capitan
    sha256 "b0af34a9c397fda92fc535830388724bb3371e10fe7ed91e8cc72849bf9356b2" => :yosemite
    sha256 "00f1906326025dffe89200c430314cff2e0f9c1b8ca42357d7c2ec5469ce23cd" => :mavericks
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/hooklift"
    ln_s buildpath, buildpath/"src/github.com/hooklift/gowsdl"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "build"
    bin.install "build/gowsdl"
  end

  test do
    system "#{bin}/gowsdl"
  end
end
