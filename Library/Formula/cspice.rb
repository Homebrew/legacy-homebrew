class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/index.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  version "65"
  sha256 "c009981340de17fb1d9b55e1746f32336e1a7a3ae0b4b8d68f899ecb6e96dd5d"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "6df710fca2dc4d81c49a486feb9ec38f54d1d6c45c88010246c818c78e13e65d" => :el_capitan
    sha256 "6e079176731ac400fb3178cd1e8d783659f4d0b39e8ac5cd0bac9e9c6f139ecd" => :yosemite
    sha256 "43d6dada0482cf26839fde38b0a074479c12b059fc24767bf09fd39e3be9ef44" => :mavericks
  end

  conflicts_with "openhmd", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"
  conflicts_with "enscript", :because => "both install `states` binaries"

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
