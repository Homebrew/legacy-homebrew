require 'formula'

class Ack < Formula
  homepage 'http://betterthangrep.com/'
  url 'https://github.com/petdance/ack/archive/1.96.tar.gz'
  sha1 '5d53b2b6f285e222a8459730495d6b07c692edd6'

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
