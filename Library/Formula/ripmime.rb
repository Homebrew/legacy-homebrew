require 'formula'

class Ripmime < Formula
  url 'http://www.pldaniels.com/ripmime/ripmime-1.4.0.9.tar.gz'
  homepage 'http://www.pldaniels.com/ripmime/'
  md5 '25761b8a533bc935f75902724fb73244'

  def install
    system "make"

    # Don't "make install", do it manually
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
