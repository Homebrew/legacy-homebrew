require 'formula'

class Lockrun < Formula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'http://unixwiz.net/tools/lockrun.c'
  version '20090625'
  sha1 '04c6df93c3ac5b2cdedfb25615f39c9ed50c0663'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
