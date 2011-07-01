require 'formula'

class Ski < Formula
  url 'http://catb.org/~esr/ski/ski-6.5.tar.gz'
  homepage 'http://catb.org/~esr/ski/'
  md5 'f9cc93f7a0223f65b011b4c873ba50df'

  def install
    bin.install "ski"
    man6.install "ski.6"
  end
end
