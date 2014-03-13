require "formula"

class Cspice < Formula
  homepage "http://naif.jpl.nasa.gov/naif/index.html"
  url "http://naif.jpl.nasa.gov/pub/naif/toolkit//C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  sha1 "e5546a72a2d0c7e337850a10d208014efb57d78d"
  version "64"

  def install
    prefix.install Dir["*"]
    cp_r "#{lib}/cspice.a", "#{lib}/libcspice.a"
  end
end
