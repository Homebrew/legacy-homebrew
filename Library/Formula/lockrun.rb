require 'formula'

class Lockrun <Formula
  url 'http://unixwiz.net/tools/lockrun.c'
  homepage 'http://unixwiz.net/tools/lockrun.html'
  md5 '40f1a02df4dd67c5e2d973b669acb45d'
  version '20090625'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
