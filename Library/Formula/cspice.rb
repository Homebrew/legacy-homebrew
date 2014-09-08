require "formula"

class Cspice < Formula
  homepage "http://naif.jpl.nasa.gov/naif/index.html"
  url "http://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  sha1 "1500a926f01a0bb04744ebe8af0149c7ae098a8f"
  version "65"

  bottle do
    cellar :any
    sha1 "095c1b894921f82dcfe230dc5519fa5b0d69e586" => :mavericks
    sha1 "24d4dbac215fa337c642f1b5f962c83fb73ad774" => :mountain_lion
    sha1 "c9c33e2601e87f6608c4b58ba51b549b6e04a0c9" => :lion
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
