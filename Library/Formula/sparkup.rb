require 'formula'

class Sparkup < Formula
  homepage 'https://github.com/rstacruz/sparkup'
  head 'git://github.com/rstacruz/sparkup.git'
  url 'https://github.com/downloads/rstacruz/sparkup/sparkup-20091205.zip'
  sha1 'b1c4d2d6499d1986d9a8f6e165512ef9ea129c7f'

  def install
    bin.install 'generic/sparkup'
  end

  def test
    system 'sparkup'
  end
end
