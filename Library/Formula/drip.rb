require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/tarball/0.0.4'
  sha1 '0960dbeb940925df8675b0088df90ab00aca97d5'

  def install
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
