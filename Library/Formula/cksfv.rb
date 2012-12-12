require 'formula'

class Cksfv < Formula
  url 'http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2'
  homepage 'http://zakalwe.fi/~shd/foss/cksfv/'
  sha1 'f6da3a559b2862691a2be6d2be0aac66cd624885'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
