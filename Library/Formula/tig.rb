require 'formula'

class Tig < Formula
  url 'https://github.com/jonas/tig/tarball/tig-0.18'
  homepage 'http://jonas.nitro.dk/tig/'
  version '0.18'
  md5 '52031d9528a2db9d87cee242a8e068fb'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    system "make install-doc-man"
  end
end
