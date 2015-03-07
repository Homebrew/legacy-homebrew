require "formula"

class Exiftool < Formula
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.76.tar.gz"
  sha1 "79bfc6beab0bdff6aa59324434e576e20785a320"

  bottle do
    cellar :any
    sha1 "b501ee8d89ecf9c87ca426bc3e6be57ad639b33e" => :yosemite
    sha1 "1fcac9cf2f8f80a9b33932bf9a79175536d0e40f" => :mavericks
    sha1 "68ca72ee036aea5a46f47f6d4952b7f1cbadd42f" => :mountain_lion
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
