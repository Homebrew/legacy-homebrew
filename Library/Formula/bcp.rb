require 'formula'

class Bcp < Formula
  homepage 'https://github.com/jwilberding/bcp'
  url 'https://github.com/jwilberding/bcp/archive/master.tar.gz'
  sha1 '7435151fe830e3b9bd7d2e309e0a2bdc8678b6b4'
  version '0.1'

  def install
    system "make"
    bin.install "bcp"
  end
end
