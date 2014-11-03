require 'formula'

class Lockrun < Formula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'http://unixwiz.net/tools/lockrun.c'
  version '1.1.3'
  sha1 '513e586884b9a7112b7da3acf53e75c84e28cda9'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
