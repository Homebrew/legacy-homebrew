require "formula"

class Exiftool < Formula
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.75.tar.gz"
  sha1 "8d201c06a71636307eef0df959f8614386f15f5c"

  bottle do
    cellar :any
    sha1 "4e911ddd5d1d8b6141e5c8c7dd90ad4bb3532e61" => :mavericks
    sha1 "f0c4dfebbc8b6798f4e1fa477b0c8c5c904c7173" => :mountain_lion
    sha1 "727aa2009ec5968d696082ac0f7ad17178a2ab3f" => :lion
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
