require 'formula'

class Ack < Formula
  url "https://github.com/petdance/ack/tarball/1.96"
  md5 '1cce67a811c52f9d51fb1195c97795f1'
  homepage 'http://betterthangrep.com/'

  def install
    system "pod2man ack ack.1"
    inreplace 'ack.1', '\*(d\-', '\*(d-' # remove a pod2man formatting error
    man1.install 'ack.1'
    bin.install 'ack'
    (prefix+'etc/bash_completion.d').install 'etc/ack.bash_completion.sh'
  end
end
