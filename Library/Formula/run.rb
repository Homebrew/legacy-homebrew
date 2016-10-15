class Run < Formula
  homepage "http://runscripts.org"
  url "https://github.com/runscripts/run/archive/0.4.0.tar.gz"
  sha256 "a1dac02d105d3e28e978cbb61adefec7b6a53181181c443ad05ba95a37d87058"
  head "https://github.com/runscripts/run.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/runscripts/run"
    system "go", "build", "-o", "run"
    bin.install "run"
    etc.install "run.conf"
    (var+"run").mkpath
  end

  test do
    system "#{bin}/run", "pt-summary"
  end
end
