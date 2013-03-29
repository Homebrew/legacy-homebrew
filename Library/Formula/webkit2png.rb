require 'formula'

class Webkit2png < Formula
  homepage 'http://www.paulhammond.org/webkit2png/'
  url 'https://github.com/paulhammond/webkit2png/archive/9c4265a82ebfcec200fca8de39fb970e5aae0a3d.tar.gz'
  version '0.5'
  sha1 '43765c86306e63b6d9d5a7c904598f3834b98b35'

  def install
    bin.install 'webkit2png'
  end
end
