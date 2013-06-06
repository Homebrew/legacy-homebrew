require 'formula'

class Spark < Formula
  homepage 'http://zachholman.com/spark/'
  url 'https://github.com/holman/spark/archive/v1.0.1.tar.gz'
  sha1 '11c6a0c5e52720a1282c5da5019432c33dcf9403'

  def install
    bin.install "spark"
  end

  def test
    system "#{bin}/spark"
  end
end
