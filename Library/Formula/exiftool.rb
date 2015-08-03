class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.99.tar.gz"
  sha256 "23025dbf72bc3079b81ce44803846b759e4e8d0da0a7ab5398eb08ff300c56b0"

  bottle do
    cellar :any
    sha256 "5aae5069133da400097b78e57b28253b107a807090262be7b0576f13db3151ca" => :yosemite
    sha256 "ed80120c9413a6894d888d95ecece0f6de01fdd2556e7998168384494ecd803b" => :mavericks
    sha256 "5004083cd34d03a182e0a52c4f26dd55e2fdeee2fb5d4c9cd76c0dda8fa1f15e" => :mountain_lion
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
