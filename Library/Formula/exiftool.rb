require "formula"

class Exiftool < Formula
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.76.tar.gz"
  sha1 "79bfc6beab0bdff6aa59324434e576e20785a320"

  bottle do
    cellar :any
    sha1 "d2a564c8010dbd98c497d88b67d49256b057ed1c" => :yosemite
    sha1 "6708a38aa6758258740e727efc29c4584dd34c09" => :mavericks
    sha1 "7312e8c438a045bc6752eaa9744e32bb20720cc5" => :mountain_lion
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
