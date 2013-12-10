require 'formula'

class Cfv < Formula
  homepage 'http://cfv.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz'
  version '1.18.3'
  sha1 '8f3361fb9c13fe2645f1df8c177c61459f50e846'
  
  depends_on :python

  def install
    man1.install gzip("cfv.1")
    bin.install "cfv"
  end
end
