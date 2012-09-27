require 'formula'

class Spark < Formula
  url 'https://github.com/holman/spark/zipball/v1.0.0'
  homepage 'https://github.com/holman/spark'
  sha1 '63971539fda9f7f3890b52ff131633f5bdda048b'

  def install
    bin.install "spark"
  end
end
