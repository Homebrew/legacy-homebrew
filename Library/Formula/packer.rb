require 'formula'

class Packer < Formula
  homepage 'https://www.packer.io'
  url 'https://dl.bintray.com/mitchellh/packer/0.2.0_darwin_amd64.zip?direct'
  sha1 '7cc9dc83586fdfab69b931baa5bb876b3ebfda6a'
  version "0.2"

  def install
    bin.install Dir['*']
  end

  test do
    system "packer"
  end
end
