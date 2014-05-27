require "formula"

class Transmute < Formula
  homepage "https://bitbucket.org/jdpalmer/transmute"
  url "https://bitbucket.org/jdpalmer/transmute/downloads/transmute-1.1.tar.gz"
  sha1 "b1449bab03da1a279d2435ff32d6061816d8ea49"

  def install
    ENV['PREFIX'] = prefix
    system "make"
    bin.install "transmute"
    man1.install "transmute.1"
  end

end
