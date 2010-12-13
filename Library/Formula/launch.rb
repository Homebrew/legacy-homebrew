require 'formula'

class Launch <Formula
  url 'http://web.sabi.net/nriley/software/launch-1.1.tar.gz'
  homepage 'http://web.sabi.net/nriley/software/'
  md5 'bcd5179d5b519248a717aa73f3819e00'

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    system "#{ENV.cc} -o launch -std=c99 #{ENV.cflags} main.c -framework ApplicationServices"
    man1.install gzip('launch.1')
    bin.install 'launch'
  end
end
