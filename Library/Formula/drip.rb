require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.2.3'
  sha1 '34ac75d9468d97f7b1fea806be9e7e821a3579d3'

  def install
    system 'make'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
