require 'formula'

class Spark < Formula
  url 'https://github.com/holman/spark/zipball/v1.0.0'
  homepage 'https://github.com/holman/spark'
  md5 'b888f1293f349bbaf1b5da0fbb73b036'

  def install
    bin.install "spark"
  end
end
