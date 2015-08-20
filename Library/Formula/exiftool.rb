class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.00.tar.gz"
  sha256 "7b573331eba3921b56339018e95dd5e6f5a1e4634e4fc7bad91e5778da3571f4"

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
