require 'formula'

class Ack < Formula
  homepage 'http://betterthangrep.com/'
  url "https://github.com/petdance/ack/tarball/1.96"
  sha1 '547058c0571095beaee9b2e6a3accad52114e759'

  def install
    system 'pod2man', 'ack', 'ack.1'
    man1.install 'ack.1'
    bin.install 'ack'
    bash_completion.install 'etc/ack.bash_completion.sh'
    zsh_completion.install 'etc/ack.zsh_completion' => '_ack'
  end

  test do
    system "#{bin}/ack", 'brew', '/usr/share/dict/words'
  end
end
