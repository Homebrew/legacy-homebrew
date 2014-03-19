require 'formula'

class Pazpar2 < Formula
  homepage 'http://www.indexdata.com/pazpar2'
  url 'http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.6.39.tar.gz'
  sha1 '2be29efecc4f0ed5a6a300638b7ef6577d1e34e4'

  depends_on 'pkg-config' => :build
  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make'
    bin.install 'src/pazpar2'
  end
end
