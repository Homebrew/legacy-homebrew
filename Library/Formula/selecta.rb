require "formula"

class Selecta < Formula
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.1.tar.gz"
  sha1 "7528a7b817ffa428759b12533e3382b5e7482603"

  def install
    bin.install 'selecta'
  end
end
