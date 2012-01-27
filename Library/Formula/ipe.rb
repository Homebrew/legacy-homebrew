require 'formula'

class Ipe < Formula
  url 'http://downloads.sourceforge.net/project/ipe7/ipe/ipe-7.0.14-src.tar.gz'
  homepage 'http://ipe7.sourceforge.net/'
  md5 '13b1790813304ac888402d9c6c40a6ec'

  depends_on 'lua'
  depends_on 'pkg-config'
  depends_on 'qt'

  def install
    cd "src"
    ENV.append 'LDFLAGS', '-liconv'
    system "make IPEPREFIX=#{prefix} IPE_USE_ICONV=-DIPE_USE_ICONV"
    system "make install IPEPREFIX=#{prefix}"
  end
end
