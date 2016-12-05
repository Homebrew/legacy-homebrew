require "language/go"

class GlodCli < Formula
  desc "Glod command-line interface tools"
  homepage "https://github.com/dwarvesf/glod-cli"
  url "https://github.com/dwarvesf/glod-cli/archive/1.0.3.2.tar.gz"
  sha256 "1826e8b5398f10a12d5f315a9f5a670f05ac3e0f6ead7c4edddf621c2260ae6c"

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  def install
    ENV["TERM"] = "xterm"
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir_p buildpath/"src/github.com/dwarvesf/"
    ln_s buildpath, buildpath/"src/github.com/dwarvesf/glod-cli"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-o", "glod-cli", "."
    bin.install "glod-cli"
  end

  test do
    system bin/"glod-cli", "http://mp3.zing.vn/bai-hat/Hello-Vietnam-Pham-Quynh-Anh/ZWZ9C8EB.html"
    sleep 2
    assert File.exist?("Hello Vietnam.mp3")
  end
end
