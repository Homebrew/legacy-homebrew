require 'formula'

class Exiftool < Formula
  homepage 'http://www.sno.phy.queensu.ca/~phil/exiftool/index.html'
  url 'http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.05.tar.gz'
  sha1 '5807ce7f4375bbe81a813f746526d5263a23b757'

  def install
    system "perl", "Makefile.PL"
    system "make", "test"

    # Install privately to the Cellar
    libexec.install "exiftool", "lib"

    # Link the executable script into "bin"
    (bin + 'exiftool').write <<-EOBIN
#!/bin/bash

which_exiftool=`which $0`
dirname_exiftool=$(dirname $which_exiftool)
readlink_exiftool=$(readlink $which_exiftool)
dirname_unlinked_exiftool=$(dirname $dirname_exiftool/$readlink_exiftool)
$dirname_unlinked_exiftool/../libexec/exiftool "$@"
EOBIN
  end

  def test
    system "#{libexec}/exiftool"
  end
end
