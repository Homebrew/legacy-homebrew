class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.05.tar.gz"
  sha256 "0876f1d505cb4244e092da90446a4b109165356b9e0fe5ab6b497609f94ddb09"

  bottle do
    cellar :any_skip_relocation
    sha256 "45c32e60439340106cc9dc148e9f175d4dfdcd0452aa48a179b3269780226cbd" => :el_capitan
    sha256 "c74d2f2cddd9395639d583e2b72cc8406041e28a353872cc5d8f940c1d63f3c1" => :yosemite
    sha256 "99125b28bebdd6144d56df4d7a860307c7a55e4c50d95145d1fd15812ef73a2f" => :mavericks
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
