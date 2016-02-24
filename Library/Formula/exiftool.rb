class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.08.tar.gz"
  sha256 "b772de5890532e5fde092f37a52a2fc1c4610e556c3886b90a501d8ee4532dd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "821d28fcad2d4e7adccc7d5b39701e75451290d2a394edda15adc9609217e529" => :el_capitan
    sha256 "8ba566128708e3bf7e048eae9f9c7cdbe2da9a6d385a81feba0b2fc2825358cd" => :yosemite
    sha256 "556e2114c7239219e04659163f883852f86d3b1547c48b1041ed9da2ce05c2cd" => :mavericks
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
