require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://github.com/buger/gor/"
  url "https://github.com/buger/gor/archive/0.9.8.tar.gz"
  sha256 "be29561352db89d5d8892443d1a6b1bb8454ec28b00854d2aecb7d91d570f4b3"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any
    sha256 "0ce768fad5dc8294e36a401d8135b02586e75525d402c8cd71818a1ac1e1b40a" => :yosemite
    sha256 "a6d61251f498b304a65c2e295af2c464f16d4647a8ed9559f6caa69e58f6d1fa" => :mavericks
    sha256 "97de5a69f364547fe8823e07c01be2d574cd10bb114fadf7268307218c6bb93b" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git", :revision => "d0e59c22a56e8dadfed24f74f452cea5a52722d2"
  end

  go_resource "github.com/buger/elastigo" do
    url "https://github.com/buger/elastigo.git", :revision => "23fcfd9db0d8be2189a98fdab77a4c90fcc3a1e9"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/buger/"
    ln_sf buildpath, buildpath/"src/github.com/buger/gor"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/gor"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gor")
  end
end
