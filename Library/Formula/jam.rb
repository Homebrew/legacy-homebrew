require 'formula'

class Jam < Formula
  homepage 'http://www.perforce.com/jam/jam.html'
  url 'ftp://ftp.perforce.com/jam/jam-2.5.zip'
  sha1 '794a3f4483315c6b9f010f03b592646d3815328c'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bin.macosx/jam", "bin.macosx/mkjambase"
  end
end
