require 'formula'

class Jam < Formula
  homepage 'http://www.perforce.com/resources/documentation/jam'
  url 'ftp://ftp.perforce.com/jam/jam-2.5.zip'
  sha1 '794a3f4483315c6b9f010f03b592646d3815328c'

  conflicts_with 'ftjam', :because => 'both install a `jam` binary'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bin.macosx/jam", "bin.macosx/mkjambase"
  end
end
