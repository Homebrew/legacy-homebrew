require "language/go"

class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl/archive/v0.2.1.tar.gz"
  sha256 "d2c6ef8a6ee5b78d9753d4a4e6ffd06c23324a4eb9de0d778ab7fc50ea6b9902"
  head "https://github.com/hooklift/gowsdl.git"

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
