class Run < Formula
  homepage "http://runscripts.org"
  url "https://github.com/runscripts/run/archive/0.4.0.tar.gz"
  sha1 "f1a726df3e06be29190d854aa5ac7e1b2a53cecb"
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
