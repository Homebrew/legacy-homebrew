require "formula"

class Mongroup < Formula
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.0.tar.gz"
  sha1 "b6472e325016353afaac04528e3226dc80401e95"

  depends_on "mon"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
