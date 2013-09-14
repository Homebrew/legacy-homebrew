require 'formula'

class Ack < Formula
  homepage 'http://beyondgrep.com/'
  url 'http://beyondgrep.com/ack-2.08-single-file'
  sha1 'c0fa19ba31ecc1afe186c5a061c1361ae2a258f3'
  version '2.08'

  def install
    bin.install "ack-2.08-single-file" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    system "#{bin}/ack", 'brew', '/usr/share/dict/words'
  end
end
