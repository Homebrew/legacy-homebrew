class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.11.tar.gz"
  sha256 "8cf8b2ec192fdbec5e1946bcf1ed9c7c681e6d16896298bbf7adb8eb59356729"

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
