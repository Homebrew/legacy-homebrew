require 'formula'

class Asciiio < Formula
  homepage 'https://github.com/sickill/ascii.io-cli'

  # always gets the latest version, since ascii.io-cli
  # doesn't have any versioning schemes going on yet
  # and master is always stable
  head 'https://github.com/sickill/ascii.io-cli.git'

  def install
    bin.install 'bin/asciiio'
  end
end
