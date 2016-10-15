require "formula"

class Totally < Formula
  homepage "https://github.com/pokle/totally"
  url "https://github.com/pokle/totally/archive/0.1.0.tar.gz"
  sha1 "dd538a9c1431c41a1276139d3936fb704e8fbefe"
  head "https://github.com/pokle/totally.git"

  def install
    bin.install "totally"
  end

  test do
    system "#{bin}/totally"
  end
end
