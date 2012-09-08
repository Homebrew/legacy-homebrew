require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.1.4'
  sha1 '564ebb5971d0366fe5e19da074b2bdf3494ac655'

  def install
    system 'make'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
