class Dlite < Formula
  desc "Provides a way to use docker on OS X without docker-machine"
  homepage "https://github.com/nlf/dlite"
  url "https://github.com/nlf/dlite/archive/1.1.3.tar.gz"
  sha256 "a87c4d7b7cd666082dc0fc44db2ca2b03efb4ee66676450c4844e7de0420d8e6"

  # DLite depends on the Hypervisor framework which only works on
  # OS X versions 10.10 (Yosemite) or newer
  depends_on :macos => :yosemite
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/nlf/dlite"
    path.install Dir["*"]

    cd path do
      system "make", "dlite"
      bin.install "dlite"
    end
  end

  def caveats
    <<-EOS.undent
      Installing and upgrading dlite with brew does not automatically
      install or upgrade the dlite daemon and virtual machine.
    EOS
  end

  test do
    output = shell_output(bin/"dlite version")
    assert_match version.to_s, output
  end
end
