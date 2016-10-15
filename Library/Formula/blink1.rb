require 'formula'

class Blink1 < Formula
  homepage 'http://thingm.com/products/blink-1.html'
  url 'https://github.com/todbot/blink1.git'
  sha1 ''

  def install
    system "cd commandline && make"
    bin.install "commandline/blink1-tool"
  end
end
