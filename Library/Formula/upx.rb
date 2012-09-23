require 'formula'

class Upx < Formula
  url 'http://upx.sourceforge.net/download/upx-3.08-src.tar.bz2'
  head 'http://upx.hg.sourceforge.net:8000/hgroot/upx/upx', :using => :hg
  homepage 'http://upx.sourceforge.net'
  sha1 '5ccbc0aacfd3aaee407eceab06ec5989bf1d153a'

  depends_on 'ucl'

  def install
    system "make all"
    bin.install "src/upx.out" => "upx"
  end
end
