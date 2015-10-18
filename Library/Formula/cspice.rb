class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/index.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  sha256 "c009981340de17fb1d9b55e1746f32336e1a7a3ae0b4b8d68f899ecb6e96dd5d"
  version "65"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d2370941fdaf3fee3ba6c18d8d44d5eb3e3fd7e2425e0c27e98c93085d410948" => :el_capitan
    sha256 "dfe2f5aa94948cb07125027c5a45938abc74dd9505a198176b2c6b2817988baa" => :yosemite
    sha256 "9f458788f92e48ab7a22a55b9b8bf94ac180f8f59ce7fc5910f049c734a845b5" => :mavericks
  end

  conflicts_with "openhmd", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"

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
