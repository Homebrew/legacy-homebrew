require 'formula'

class Nave < Formula
  homepage 'https://github.com/isaacs/nave'
  url 'https://github.com/isaacs/nave/tarball/v0.3.0'
  sha1 'ee6ae7a676e725c7b8e9788b3b2a00ea2db6dd91'
  version '0.3.0'

  def install
    system "ln -sf nave.sh nave"
    system "mkdir -p #{prefix}"
    system "cp * #{prefix}"
  end

  def test
    system "nave"
  end
end
