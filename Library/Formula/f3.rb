require 'formula'

class F3 < Formula
  url 'http://oss.digirati.com.br/f3/f3v2.zip'
  homepage 'http://oss.digirati.com.br/f3/'
  md5 'e1e196895c424b7aae15bdf67cfea862'

  def install
    system "make mac"
    doc.install 'README'
    doc.install 'LICENSE'
    bin.install 'f3read'
    bin.install 'f3write'
  end

  def test
    system "f3write"
    system "f3read"
  end
end
