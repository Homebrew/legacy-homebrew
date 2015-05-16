require 'formula'

class Brag < Formula
  homepage 'http://brag.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz'
  sha1 'e79547ecb710153a13b54080be5d2b83944616d2'

  depends_on 'uudeview'

  def install
    bin.install "brag"
    man1.install "brag.1"
  end

  test do
    system "#{bin}/brag", "-s", "news.bu.edu", "-L"
  end
end
