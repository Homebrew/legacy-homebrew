require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.0.3'
  sha1 '6cd5d2346314e3adda71ceeccf037e863b12c8c3'

  def install
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
