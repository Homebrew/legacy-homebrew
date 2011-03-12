require 'formula'

class ClustalW <Formula
  url 'http://www.clustal.org/download/2.0.12/clustalw-2.0.12.tar.gz'
  homepage 'http://www.clustal.org/'
  md5 '8d0c50ffbe5898b03509aa0a7709f642'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
