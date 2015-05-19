class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.96.tar.gz"
  sha256 "2e381c8b5ea364f51e2d31bd9e511750b82a71701bd0ee77e0049cf2a6daa813"

  bottle do
    cellar :any
    sha256 "62736b9e4361784b431be5bcddb177517275f951a4b485c4f57eb2e3942c6e9b" => :yosemite
    sha256 "fcff7d4cb079b255a4ac10c55a6f30fa3e7767c0351736ef9701daa783d28d96" => :mavericks
    sha256 "5681c568a351c32079040fb74022613d10aad09377abe32f6fa5deb4036075ec" => :mountain_lion
  end

  def install
    system "perl", "Makefile.PL"
    system "make", "test"

    # Install privately to the Cellar
    libexec.install "exiftool", "lib"

    # Link the executable script into "bin"
    (bin + "exiftool").write <<-EOBIN
#!/bin/bash

which_exiftool=`which $0`
dirname_exiftool=$(dirname $which_exiftool)
readlink_exiftool=$(readlink $which_exiftool)
dirname_unlinked_exiftool=$(dirname $dirname_exiftool/$readlink_exiftool)
$dirname_unlinked_exiftool/../libexec/exiftool "$@"
EOBIN
  end

  test do
    system "#{libexec}/exiftool"
  end
end
