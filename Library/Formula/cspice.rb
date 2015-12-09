class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/index.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  version "65"
  sha256 "c009981340de17fb1d9b55e1746f32336e1a7a3ae0b4b8d68f899ecb6e96dd5d"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "daa552c39c338739c8c435d1b7c5c77975172905ff91b5893667da6ad60f7a7e" => :el_capitan
    sha256 "fda8c9832e01c3b51bf68981434501632083a0a88909f62b4248f63f248a5971" => :yosemite
    sha256 "61e4b947ed7223919ae92ddfcaf1f64267ab8d27467bcfb4de51cbdd10edbaa1" => :mavericks
  end

  conflicts_with "openhmd", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"
  conflicts_with "enscript", :because => "both install `states` binaries"
  conflicts_with "fondu", :because => "both install `tobin` binaries"

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
