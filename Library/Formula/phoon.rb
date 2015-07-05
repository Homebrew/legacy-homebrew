class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "http://www.acme.com/software/phoon/"
  url "http://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end
end
