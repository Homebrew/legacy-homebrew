require "formula"

class Run < Formula
  homepage "http://runscripts.org"
  url "https://github.com/runscripts/run/archive/0.3.6.tar.gz"
  sha1 "0f181b6a3bb56769cdbc46e6d0431a00d2cf3b9c"
  head "https://github.com/runscripts/run.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/runscripts/run"
    system "go", "build", "-o", "run"
    bin.install "run"
    etc.install "run.conf"
    (HOMEBREW_PREFIX+"run").mkpath
  end

  test do
    system "#{bin}/run", "--help"
  end
end
