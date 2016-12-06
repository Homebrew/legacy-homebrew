require "language/go"

class ConohaIso < Formula
  desc "Command wrapper to use ISO of ConoHa."
  homepage "https://github.com/hironobu-s/conoha-iso"
  url "https://github.com/hironobu-s/conoha-iso/archive/current.tar.gz"
  version "0.2.1"
  sha256 "a922d949295ca05f8b3267df471e56bc36590aa9ceacb4ad0d972abdc8192b0a"

  depends_on "go"  => :build

  patch do
    url "https://gist.githubusercontent.com/neronplex/4770e56b72f363423ed5/raw/6ff8172b4e6627a60b2c353bf752b18b80ad73f3/patch-conoha-iso.diff"
    sha256 "a5af20f571ee23c3d9ba6c2b604c84ddbd1cc3d7f6f0d1fa43f3722dc6fd9ec3"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git", :revision => "418b41d23a1bf978c06faea5313ba194650ac088"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :revision => "565493f259bf868adb54d45d5f4c68d405117adf"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/hironobu-s/"
    ln_s buildpath, buildpath/"src/github.com/hironobu-s/conoha-iso"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath do
      system "go", "build", "-o", bin/"conoha-iso", "run.go"
    end
  end

  test do
    assert_match /conoha-iso version 0.2.1/, shell_output("#{bin}/conoha-iso --version")
  end
end
