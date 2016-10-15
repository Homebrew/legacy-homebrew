require "formula"

class YhatSb < Formula
  homepage "http://yhat.github.io/sciencebox/"
  url "http://yhat-release.s3.amazonaws.com/dists/yhat-sb-cli/yhat-sb-v0.0.5.tar.gz"
  sha1 "f5508b90f64e7cbe9dd1998defd807f452ffd1a8"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/codegangsta/cli"
    system "go", "get", "github.com/fatih/color"
    system "make"
    bin.install "sb"
  end
end
