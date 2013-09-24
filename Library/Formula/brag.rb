require 'formula'

class Brag < Formula
  homepage 'http://brag.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz'
  sha1 'e79547ecb710153a13b54080be5d2b83944616d2'

  depends_on 'uudeview'

  def install
    # The install target of the Makefile that ships with brag is very simple
    # yet assumes paths and permissions.  Since only 5 files were being
    # copied it seemed appropriate to just reproduce the functionality here
    # (especially since there hasn't been a new release of brag since 2004)
    bin.install("brag")
    man1.install("brag.1")
    doc.install("CHANGES")
    doc.install("LICENSE")
    doc.install("README")
  end

  test do
    system "#{bin}/brag", "-s", "news.bu.edu", "-L"
  end
end
