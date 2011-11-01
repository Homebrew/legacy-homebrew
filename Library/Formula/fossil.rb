require 'formula'

class Fossil < Formula
  version '1.20'
  url 'http://www.fossil-scm.org/download/fossil-src-20111021125253.tar.gz'
  md5 'd3bd7d3bf60b523578f37315cd8a8f12'
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
