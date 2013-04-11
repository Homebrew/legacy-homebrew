require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/archive/0.2.3.tar.gz'
  sha1 '01f498c20444d5295ffc5c531f7f8a4a894681c6'

  def install
    system 'make'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
