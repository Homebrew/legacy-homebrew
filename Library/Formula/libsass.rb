require 'formula'

class Libsass < Formula
  homepage 'https://github.com/hcatlin/libsass'
  url 'https://github.com/hcatlin/libsass/tarball/580c318bacbcc33f58ae4cfe8a82561ab0e04b0d'
  sha1 'b266103d0dff22c6702587859cf1c6c640e23ed8'
  version '580c318bacbcc33f58ae4cfe8a82561ab0e04b0d'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "test -e #{prefix}/lib/libsass.a"
  end
end
