require 'formula'

class Lockrun < Formula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'http://unixwiz.net/tools/lockrun.c'
  version '20130426'
  sha1 '6b1e20f5413f02c93ff24e7f3eab28d01f66a1b6'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
