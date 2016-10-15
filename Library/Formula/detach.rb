class Detach < Formula
  homepage "http://inglorion.net/software/detach/"
  url "https://github.com/mithun/detach/archive/0.5.0.tar.gz"
  sha1 "9b9ddd595b35512d6b7a62941146962266fd86f5"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

end
