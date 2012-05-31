require 'formula'

class Jam < Formula
  homepage 'http://www.perforce.com/jam/jam.html'
  url 'ftp://ftp.perforce.com/jam/jam-2.5.zip'
  md5 'f92caadb62fe4cb0b152eff508c9d450'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bin.macosx/jam", "bin.macosx/mkjambase"
  end
end
