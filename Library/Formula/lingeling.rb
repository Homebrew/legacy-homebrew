require 'formula'

class Lingeling < Formula
  url 'http://fmv.jku.at/lingeling/lingeling-276-6264d55-100731.tar.gz'
  version '276'
  homepage 'http://fmv.jku.at/lingeling'
  md5 '2da261fa61e494b83987874628188cb1'

  def install
    system "./configure"
    system "make"
    bin.install %w{ lingeling plingeling }
  end
end
