require "formula"

class Megacmd < Formula
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.012.tar.gz"
  sha1 "30690366ef00b64296cd4acca6f842d83dcc9d69"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    sha1 "6ee3f124bf3c9eae280aefb07f2d25af8353a779" => :mavericks
    sha1 "8292dfa4c648bbe95d1f9752c63ff3dd78104891" => :mountain_lion
    sha1 "c49c5876032f94ec4e3d2ff71632f347d08191c0" => :lion
  end

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
