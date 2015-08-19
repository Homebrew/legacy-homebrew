class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "http://vpcs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/vpcs/0.6/vpcs-0.6-src.tbz"
  sha256 "cc311b0dea9ea02ef95f26704d73e34d293caa503600a0acca202d577afd3ceb"

  bottle do
    cellar :any
    sha1 "b1cb4c4c1dfabe6a1583aae0dd9387868739cfce" => :yosemite
    sha1 "e396c21bd1cc5c883ff0a92d74cd497d74fb20bd" => :mavericks
    sha1 "65669a992ac54d5b642beb9c8d90895b70c7a711" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.osx"
      bin.install "vpcs"
    end
  end

  test do
    system "vpcs", "--version"
  end
end
