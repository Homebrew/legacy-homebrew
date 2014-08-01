require "formula"

class Mavis < Formula
  homepage "http://mavis.kasoki.de"
  url "https://github.com/kasoki/mavis/archive/v0.1.1.tar.gz"
  sha1 "d3a92fb0fac0fdbb78f1e05386b82039ee9fca57"

  depends_on "premake" => :build

  def install
    system "premake4", "gmake"
    system "make"

    lib.install "libmavis.dylib"
    include.install "mavis/include/mavis"
  end
end
