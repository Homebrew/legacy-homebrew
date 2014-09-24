require "formula"

class Periodic < Formula
  homepage "https://github.com/Lupino/periodic"
  url "https://github.com/Lupino/periodic/releases/download/v0.1.2/periodic-osx"
  version '0.1.2'
  sha1 "7a8dd55cfbc52400dde4bf14d891c07a601bddbe"

  def install
    bin.install "periodic-osx" => "periodic"
  end

  test do
    system "#{bin}/periodic -h"
  end
end
