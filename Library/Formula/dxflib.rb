require 'formula'

class Dxflib < Formula
  homepage 'http://www.ribbonsoft.com/en/what-is-dxflib'
  url 'http://www.ribbonsoft.com/archives/dxflib/dxflib-2.5.0.0-1.src.tar.gz'
  version '2.5.0.0-1'
  sha1 'af2e496aaf097e40bdb5d6155ba9b0d176d71729'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
