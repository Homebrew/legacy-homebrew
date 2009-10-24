require 'formula'

class Swftools <Formula
  url 'http://www.swftools.org/swftools-0.9.0.tar.gz'
  homepage 'http://www.swftools.com'
  md5 '946e7c692301a332745d29140bc74e55'

  depends_on 'jpeg'
  depends_on 'xpdf'
  depends_on 'libpng'

  def install
    ENV.minimal_optimization
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
