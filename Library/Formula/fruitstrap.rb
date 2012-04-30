require 'formula'

class Fruitstrap < Formula
  homepage 'https://github.com/ghughes/fruitstrap'
  url 'https://github.com/ghughes/fruitstrap/tarball/6a3077f99a6e51658a0052ec03d558ed78ec43ff'
  md5 '4ac4b636541867a0205456d227b9fd54'
  version '6a3077f'

  def install
    system "make fruitstrap"
    bin.install "fruitstrap"
  end

  def test
    system "fruitstrap"
  end
end
