require "formula"

class Cspice < Formula
  homepage "http://naif.jpl.nasa.gov/naif/index.html"
  url "http://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  sha1 "1500a926f01a0bb04744ebe8af0149c7ae098a8f"
  version "65"

  bottle do
    cellar :any
    sha1 "be5a92d5a4a1e6f19ba6b03a4fe8bca227a64d9d" => :mavericks
    sha1 "d2b58e8648bcd288a50bf852448a8c0a27c717b3" => :mountain_lion
    sha1 "1a41bc5c47948c6b7e9288bb2c365573461df460" => :lion
  end

  def install
    rm_f Dir["lib/*"]
    rm_f Dir["exe/*"]
    system "csh", "makeall.csh"
    mv "exe", "bin"
    (share/"cspice").install "doc", "data"
    prefix.install "bin", "include", "lib"

    lib.install_symlink "cspice.a" => "libcspice.a"
    lib.install_symlink "csupport.a" => "libcsupport.a"
  end

  test do
    system "#{bin}/tobin", "#{share}/cspice/data/cook_01.tsp", "DELME"
  end
end
