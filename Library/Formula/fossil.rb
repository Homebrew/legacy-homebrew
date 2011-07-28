require 'formula'

class Fossil < Formula
  version '1.18'
  url 'http://www.fossil-scm.org/download/fossil-src-20110713230341.tar.gz'
  md5 'ed916bc0db85f30eadd0de45f6bc95ad'
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "make"
    bin.install 'fossil'
  end
end
