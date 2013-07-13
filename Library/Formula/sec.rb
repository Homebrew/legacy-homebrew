require 'formula'

class Sec < Formula
  homepage 'http://simple-evcorr.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.4/sec-2.7.4.tar.gz'
  sha1 'a19d100d0340116bb227e835cb822f8c76d6f243'

  def install
    bin.install 'sec'
    man1.install 'sec.man' => 'sec.1'
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
