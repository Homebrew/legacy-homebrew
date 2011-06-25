require 'formula'

class Upx < Formula
  url 'http://upx.sourceforge.net/download/upx-3.05-src.tar.bz2'
  homepage 'http://upx.sourceforge.net'
  md5 '1f0ca94c8c26a816402274dd7e628334'

  depends_on 'ucl'

  def install
    system "make all"
    system "src/upx.out src/upx.out"
    bin.install "src/upx.out" => "upx"
  end
end
