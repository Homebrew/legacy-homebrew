require 'formula'

class W3m <Formula
  url 'http://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.2/w3m-0.5.2.tar.gz'
  homepage 'http://w3m.sourceforge.net/'
  md5 'ba06992d3207666ed1bf2dcf7c72bf58'

  depends_on 'bdw-gc'

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-image"
    system "make install"
  end
end
