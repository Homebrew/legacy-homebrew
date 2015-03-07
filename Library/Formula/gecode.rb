require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-4.3.3.tar.gz'
  sha1 '392f079979a582e040ff1d58736f23e985ca53ff'

  bottle do
    cellar :any
    sha1 "ba6eb629c7c589313b01f7f1fa9e7efaa982e484" => :yosemite
    sha1 "0e92784b621811737eabc4a002452fdf549e015c" => :mavericks
    sha1 "e63ad8a3f8313fbf61a6d58b8db5bc82cb9b562e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end
