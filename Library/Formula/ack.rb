require 'formula'

class Ack < ScriptFileFormula
  homepage 'http://beyondgrep.com/'
  url 'https://github.com/petdance/ack2/archive/2.04.tar.gz'
  sha1 'b9241ea000b089609d7e62f241c1ef7ad0d70cc6'

  def install
    bin.install "garage/ack-#{version}" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    system "#{bin}/ack", 'brew', '/usr/share/dict/words'
  end
end
