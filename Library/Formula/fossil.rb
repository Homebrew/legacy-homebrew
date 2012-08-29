require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20120808112557.tar.gz'
  md5 '023f2d45b2435a854f8b9190d1aee05b'
  version '1.23'

  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
