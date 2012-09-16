require 'formula'

class Lockrun < Formula
  url 'http://unixwiz.net/tools/lockrun.c'
  homepage 'http://unixwiz.net/tools/lockrun.html'
  sha1 '04c6df93c3ac5b2cdedfb25615f39c9ed50c0663'
  version '20090625'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
