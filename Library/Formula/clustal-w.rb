require 'formula'

class ClustalW < Formula
  homepage 'http://www.clustal.org/'
  url 'http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz'
  sha1 'f29784f68585544baa77cbeca6392e533d4cf433'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
