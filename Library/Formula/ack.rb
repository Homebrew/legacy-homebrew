require 'formula'

class Ack < Formula
  homepage 'http://beyondgrep.com/'
  url 'http://beyondgrep.com/ack-2.10-single-file'
  sha1 '6052cee5a4f580006fb9135e46411c5322c24a2a'
  version '2.10'

  def install
    bin.install "ack-2.10-single-file" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    system "#{bin}/ack", '--version'
  end
end
