require "formula"

class Exiftool < Formula
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.69.tar.gz"
  sha1 "9ff75f95fbfdb3e09baaab0822ec17db696a1458"

  bottle do
    cellar :any
    sha1 "8f5960caec6c5596b9dcd779cd546c62a2d07020" => :mavericks
    sha1 "2412d28c8aa2156c11dbf0bd5219d300aaab0797" => :mountain_lion
    sha1 "c1b26c0d20d49c261113f3a9353d57a1419d10af" => :lion
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
