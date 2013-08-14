require 'formula'

class Gitio < Formula
  homepage 'https://github.com/cocoahero/gitio'
  url 'https://github.com/cocoahero/gitio/archive/v0.0.2.zip'
  sha1 'b3ce8a3d8d8cdfdd5162e705eadfc87027881e5b'

  def install
    bin.install "bin/gitio"
  end

  test do
    system "#{bin}/gitio"
  end
end
