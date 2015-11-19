class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "http://vpcs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/vpcs/0.6/vpcs-0.6-src.tbz"
  sha256 "cc311b0dea9ea02ef95f26704d73e34d293caa503600a0acca202d577afd3ceb"

  bottle do
    cellar :any
    sha256 "d905fc7dd6ca0dd07a0bafb6d8e71bebd0d2c3c516c0c00f6adb87aebf6d7057" => :yosemite
    sha256 "a6a5285281f81b0f035b024f0f8e81211ac71f69390c5c6d03820ce7eccdc116" => :mavericks
    sha256 "713bc04995e9cbe4cafc759643035b0b34431c5c3e559ff60ede0e674cfe4538" => :mountain_lion
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
