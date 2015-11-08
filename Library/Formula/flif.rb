class Flif < Formula
  desc "Free Lossless Image Format"
  homepage "http://flif.info"
  url "https://github.com/FLIF-hub/FLIF/archive/v0.1-alpha.tar.gz"
  version "0.1-alpha"
  sha256 "b15229e07b43758bb993aa912a08d66f62e078e3f4964b13ffe7a13b6b3ecd07"

  head "https://github.com/FLIF-hub/FLIF.git"

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make"

    bin.mkpath
    bin.install "flif"
    include.install %w[flif.h flif_config.h]
  end

  test do
    system bin/"flif", "--help"
  end
end
