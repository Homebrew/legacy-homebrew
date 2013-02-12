require 'formula'

class Spark < Formula
  homepage 'http://zachholman.com/spark/'
  url 'https://github.com/holman/spark/zipball/v1.0.1'
  sha1 'c44be4dee3b375ce2a33d096ff41ed3212eaa7ce'

  def install
    bin.install "spark"
  end

  def test
    system "#{bin}/spark"
  end
end
