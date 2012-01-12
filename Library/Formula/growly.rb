require 'formula'

class Growly < Formula
  homepage 'https://github.com/ryankee/growly'
  head 'https://github.com/ryankee/growly.git'
  url 'https://github.com/downloads/ryankee/growly/growly-v0.2.0.tar.gz'
  md5 'a3e4922d619cfeb00009dc55163f0974'

  def install
    bin.install 'growly'
  end

  def test
    system 'growly "echo Hello, world!"'
  end
end
