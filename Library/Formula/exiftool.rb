class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.11.tar.gz"
  sha256 "8cf8b2ec192fdbec5e1946bcf1ed9c7c681e6d16896298bbf7adb8eb59356729"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ba5c8524d2462d8a6608ebffef9c4e2b8fa923d809c4292c044768a7d9db809" => :el_capitan
    sha256 "d76b0cd4853457378e8d527419e8cea8a5d8e63487e75a43c943ee943a4caed9" => :yosemite
    sha256 "28920f699adb9e45ec79a9e504721b7984f1a9c82309bfdf0ad1917480e88057" => :mavericks
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
