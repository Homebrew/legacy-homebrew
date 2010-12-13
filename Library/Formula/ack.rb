require 'formula'

class Ack < Formula
  url "https://github.com/petdance/ack/tarball/1.94"
  md5 '6c75e25bb29e24f89f77f2ee6deb29e8'
  homepage 'http://betterthangrep.com/'

  def install
    bin.install 'ack'
    (prefix+'etc/bash_completion.d').install 'etc/ack.bash_completion.sh'
  end
end
