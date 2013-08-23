require 'formula'

class Lzma < Formula
  url 'http://downloads.sourceforge.net/project/sevenzip/LZMA%20SDK/4.65/lzma465.tar.bz2'
  sha1 '5ec1c4606fec88c770a9712073e83916f8aed173'
end

class Upx < Formula
  homepage 'http://upx.sourceforge.net'
  url 'http://upx.sourceforge.net/download/upx-3.09-src.tar.bz2'
  sha1 'df474a9909e6697a4d3240767c34e2dcb39002c1'
  head 'https://www.pysol.org:4443/hg/upx.hg', :using => :hg

  depends_on 'ucl'

  def install
    Lzma.new.brew {(buildpath+'lzmasdk').install Dir['*']}
    ENV['UPX_LZMADIR'] = (buildpath+'lzmasdk')
    ENV['UPX_LZMA_VERSION'] = '0x465'
    system "make all"
    bin.install  'src/upx.out' => 'upx'
    man1.install 'doc/upx.1'
  end
end
