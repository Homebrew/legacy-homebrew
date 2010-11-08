require 'formula'

class Ack < Formula
  url "https://github.com/petdance/ack/tarball/1.93_02"
  md5 'b468ce41a949fd957dc9b6aee74782e9'
  homepage 'http://betterthangrep.com/'

  def install
    bin.install 'ack'
    (prefix+'etc/bash_completion.d').install 'etc/ack.bash_completion.sh'
  end
end
