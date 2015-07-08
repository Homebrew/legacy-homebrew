require 'formula'

class Jam < Formula
  desc "Make-like build tool"
  homepage 'http://www.perforce.com/resources/documentation/jam'
  url 'https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.zip'
  sha1 'e6d2f909798fad32f3bd7c08699265f82b05b526'

  conflicts_with 'ftjam', :because => 'both install a `jam` binary'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end
end
