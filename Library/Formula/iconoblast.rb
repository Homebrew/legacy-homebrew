class Iconoblast < Formula
  desc "App icon dev info burning for iOS and Android."
  homepage "https://github.com/mapbox/iconoblast"
  url "https://github.com/mapbox/iconoblast/archive/v0.0.1.tar.gz"
  version "0.0.1"
  sha256 "9dadb03d629a9cc1251fb4b2b9a06209fe733728728ca31c349d868a47d2102b"

  depends_on "ghostscript"
  depends_on "imagemagick"

  def install
    bin.install "iconoblast"
  end
end
