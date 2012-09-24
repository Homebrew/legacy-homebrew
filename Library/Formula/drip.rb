require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.1.7'
  sha1 'c9d2a027759e425625ab170cf5012c75807e6093'

  def install
    system 'make'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
