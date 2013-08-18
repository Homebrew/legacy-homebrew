require 'formula'

class Exiftool < Formula
  homepage 'http://www.sno.phy.queensu.ca/~phil/exiftool/index.html'
  url 'http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.35.tar.gz'
  sha1 '44be3a5c49c2fb0df0e9778bb50aece2bf67fe25'

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
