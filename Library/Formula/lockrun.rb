require 'formula'

class Lockrun <Formula
  url 'http://unixwiz.net/tools/lockrun.c'
  homepage 'http://unixwiz.net/tools/lockrun.html'
  md5 '094b6c41be239de2ded94b9b7f590004'
  version '20090625'

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
