require 'formula'

class Spacefinder < Formula
  version 'ae27b03'
  url 'https://github.com/shabble/osx-space-id/tarball/master'
  homepage 'https://github.com/shabble/osx-space-id'
  md5 'd84b0f6b98ef93f824ee7e2ecc31fdc4'

  def install
    system "make"
    bin.install "spacefinder"
  end
end
