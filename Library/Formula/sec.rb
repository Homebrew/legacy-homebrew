require 'formula'

class Sec < Formula
  homepage 'http://simple-evcorr.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.3/sec-2.7.3.tar.gz'
  sha1 '926747fb34e45597d24cf6b7a44b9d23be01f7d0'

  def install
    bin.install 'sec'
    man1.install 'sec.man' => 'sec.1'
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
