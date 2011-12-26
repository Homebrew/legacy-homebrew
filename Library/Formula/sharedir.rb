require 'formula'

class Sharedir < Formula
  url 'https://github.com/caiogondim/sharedir/tarball/v0.1'
  homepage 'http://caiogondim.github.com/sharedir/'
  md5 '0a81179c23b8a51b2964d3312f4171a3'

  def install
    bin.install 'sharedir'
  end
end
