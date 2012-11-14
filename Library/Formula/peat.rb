require 'formula'

class Peat < Formula
  homepage 'https://github.com/sjl/peat'
  url 'https://github.com/sjl/peat/tarball/v0.1.0'
  sha1 'a96e3f095c5611121d63972505f2720781ca46db'

  def install
    bin.install "peat"
  end

  def test
    system "peat"
  end
end
