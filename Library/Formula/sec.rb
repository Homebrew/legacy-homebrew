require 'formula'

class Sec < Formula
  homepage 'http://simple-evcorr.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.5/sec-2.7.5.tar.gz'
  sha1 'ceb2d0c27096306d8605354de87cc39c0fecaa03'

  def install
    bin.install 'sec'
    man1.install 'sec.man' => 'sec.1'
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
