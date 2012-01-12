require 'formula'

class Upx < Formula
  url 'http://upx.sourceforge.net/download/upx-3.07-src.tar.bz2'
  homepage 'http://upx.sourceforge.net'
  md5 '8186ab103288242f7e8ecad1acd4af03'

  depends_on 'ucl'

  def install
    system "make all"
    system "src/upx.out src/upx.out"
    bin.install "src/upx.out" => "upx"
  end
end
