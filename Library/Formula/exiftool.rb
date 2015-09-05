class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.00.tar.gz"
  sha256 "7b573331eba3921b56339018e95dd5e6f5a1e4634e4fc7bad91e5778da3571f4"

  bottle do
    cellar :any
    sha256 "1bb061e6f38466bbbe8b59787c9bf6e29532c12db4b7762a48d8d96923929cfb" => :yosemite
    sha256 "84f4222a30768b0c9891a1a32912d8f62ff64b26d3285c89774a8056f8843824" => :mavericks
    sha256 "b0d3125dcfa56ffc2417ccbe40558257f634914821fbe86ae7c2a263276a7bec" => :mountain_lion
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
