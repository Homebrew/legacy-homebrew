require 'formula'

class Brag < Formula
  homepage 'http://brag.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz'
  sha1 'e79547ecb710153a13b54080be5d2b83944616d2'

  depends_on 'uudeview'

  def patches
    # fixes makefile for man path and file ownership
    { :p0 => "https://gist.github.com/grahams/6687654/raw" }
  end

  def install
    system "make -e ROOT=#{prefix} install"
  end

  test do
    system '#{bin}/brag -s news.bu.edu -L'
  end
end
