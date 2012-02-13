require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20111213135356.tar.gz'
  version '1.21'
  md5 'd3bd7d3bf60b523578f37315cd8a8f12'
  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
