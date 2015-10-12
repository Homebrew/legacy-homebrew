class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.01.tar.gz"
  sha256 "46b6418334b2ca4e3b21cd38a6cb88131f5256cd21472160b4d19ac078093ceb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f114919fcb753ee3f0894b2abb081211bc2e8e86563ee9ded3db0c9f90e1f7fa" => :el_capitan
    sha256 "279660c10e3436ff9f25c692bd0287f63a4df4ce332fc794c5173409041b5873" => :yosemite
    sha256 "ef420fd3dd314fda1a1f94a7e2a20343955995b9cc81f47bb266633358d4b3cb" => :mavericks
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
