require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.1.3'
  sha1 '12e818bc1eca23a9eb09c033023aedf35c646f41'

  def install
    system 'bin/drip'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
