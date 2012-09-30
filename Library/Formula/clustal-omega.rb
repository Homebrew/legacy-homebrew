require 'formula'

class ClustalOmega < Formula
  homepage 'http://www.clustal.org/omega/'
  url 'http://www.clustal.org/omega/clustal-omega-1.1.0.tar.gz'
  version '1.1.0'
  sha1 'b8c8ac500811c50a335c9dc2fcaf47a7245fa6a0'

  depends_on 'cmake' => :build
  depends_on 'argtable'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
