require 'formula'

class Ack < Formula
  url "https://github.com/petdance/ack/tarball/1.96"
  md5 '1cce67a811c52f9d51fb1195c97795f1'
  homepage 'http://betterthangrep.com/'

  def install
    bin.install 'ack'
    (prefix+'etc/bash_completion.d').install 'etc/ack.bash_completion.sh'
  end
end
