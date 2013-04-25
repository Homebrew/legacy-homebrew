require 'formula'

class Ack < ScriptFileFormula
  homepage 'http://beyondgrep.com/'
  url 'http://beyondgrep.com/ack-2.02-single-file'
  sha1 '94b09ed23b50c0c644aa386f4a3c51ed2edea821'
  version '2.02'

  def install
    bin.install "ack-#{version}-single-file" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    system "#{bin}/ack", 'brew', '/usr/share/dict/words'
  end
end
