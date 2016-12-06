require 'formula'

class Heatshrink < Formula
  homepage 'http://github.com/atomicobject/'
  url 'https://nodeload.github.com/atomicobject/heatshrink/legacy.tar.gz/7b72b094e2641c349caaf3ec19fe295990a8ad5f'
  sha1 'e7992d9ba92afb82f7a6f40ca1ec39efefa961ca'
  version '0.1.0'

  def install
    system "make heatshrink"
    bin.install 'heatshrink'
  end
end
