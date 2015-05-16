require "formula"

class Exiftool < Formula
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.90.tar.gz"
  sha256 "64f602773cd2051fd3ab614464f4b39492383ba2742263cddbb4df27855b7089"

  bottle do
    cellar :any
    sha256 "28b576135c1968a4ad107eabddaea0086150ca70ed3de0790871154d2fdadb26" => :yosemite
    sha256 "ca7ed38e4fe76644e31ba0bb0b6c2375dadb0333fb5543c8dce9dc9f9a2b46a0" => :mavericks
    sha256 "834aee0a09414ff3d38282de3bb0a3cc5cb63f28413b5be16952424ebda9dc3f" => :mountain_lion
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
