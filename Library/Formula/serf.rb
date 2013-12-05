require 'formula'

class Serf < Formula
  homepage 'http://serfdom.io'
  version '0.2.1'

  if Hardware.is_64_bit? 
    url 'https://dl.bintray.com/mitchellh/serf/0.2.1_darwin_amd64.zip'
    sha256 'e6cf1d071431efbfcfdc9dab19cef17df6703b692022892ef469796410ff3cfb'
  else
    url 'https://dl.bintray.com/mitchellh/serf/0.2.1_darwin_386.zip'
    sha256 'ebd6f8f66ed10b43a7db469d2310fcbf253cd9c08b7e61bec4155cddc383c0bd'
  end 

  def install
    bin.install Dir['*']
  end
end
