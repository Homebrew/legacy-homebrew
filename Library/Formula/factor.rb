require 'formula'

# This formula installs Factor TRUNK, as there is no
# good stable release. It also takes up to and including
# "a very long time" to bootstrap the image.

class Factor <Formula
  head 'git://github.com/slavapestov/factor.git'
  homepage 'http://factorcode.org/'

  def install
    system "make"
    curl "http://factorcode.org/images/latest/boot.unix-x86.64.image", "-O"
    system "./factor -i=boot.unix-x86.64.image"
    libexec.install "Factor.app"
    libexec.install "factor.image"
  end

  def caveats
    "Cocoa app installed to #{libexec}.\n\n"\
    "Makes use of 'factor.image' in the same folder."
  end
end
