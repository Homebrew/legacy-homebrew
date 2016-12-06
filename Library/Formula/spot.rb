require 'formula'

class Spot < Formula
  homepage 'https://github.com/guille/spot'
  url 'git://github.com/guille/spot.git'
  version 'git'

  def install
    File.rename("spot.sh", "spot")
    bin.install ["spot"]
    man1.install ["spot.1"]
  end

  def test
    system "spot"
  end
end
