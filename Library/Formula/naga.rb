require "formula"

class Naga < Formula
  homepage "http://github.com/anayjoshi/naga/"
  url "http://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha1 "4d80a2d9ef53f877bf0c8c132fb8ea2deeff8f0d"
  version "1.0"

  depends_on "scons"

  def install
    system "scons", "install" , "install_path=#{bin}"
  end

  test do
    system "true"
  end
end
