require "formula"

class Megacmd < Formula
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.012.tar.gz"
  sha1 "30690366ef00b64296cd4acca6f842d83dcc9d69"
  head "https://github.com/t3rm1n4l/megacmd.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install File.basename(buildpath) => "megacmd"
  end

  test do
    system "megacmd", "--version"
  end
end
