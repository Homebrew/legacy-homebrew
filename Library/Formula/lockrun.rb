require 'formula'

class Lockrun < Formula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'http://unixwiz.net/tools/lockrun.c'
  version '20120905'
  sha1 'dc8442d806608c45bab9d9062e5028b6d8f35c0c'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
