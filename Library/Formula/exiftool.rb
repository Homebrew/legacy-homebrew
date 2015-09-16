class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.01.tar.gz"
  sha256 "46b6418334b2ca4e3b21cd38a6cb88131f5256cd21472160b4d19ac078093ceb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b53cfae70644d3cbe64a4650cb2ed688359960c6fbb001c471b61271a555223" => :el_capitan
    sha256 "1bb061e6f38466bbbe8b59787c9bf6e29532c12db4b7762a48d8d96923929cfb" => :yosemite
    sha256 "84f4222a30768b0c9891a1a32912d8f62ff64b26d3285c89774a8056f8843824" => :mavericks
    sha256 "b0d3125dcfa56ffc2417ccbe40558257f634914821fbe86ae7c2a263276a7bec" => :mountain_lion
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", "#{libexec}/lib"

    system "perl", "Makefile.PL"

    libexec.install "lib"
    bin.install "exiftool"
  end

  test do
    system "#{bin}/exiftool"
  end
end
