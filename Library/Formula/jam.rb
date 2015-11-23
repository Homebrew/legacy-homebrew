class Jam < Formula
  desc "Make-like build tool"
  homepage "http://www.perforce.com/resources/documentation/jam"
  url "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.zip"
  sha256 "7c510be24dc9d0912886c4364dc17a013e042408386f6b937e30bd9928d5223c"

  conflicts_with "ftjam", :because => "both install a `jam` binary"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end
end
