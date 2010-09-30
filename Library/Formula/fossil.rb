require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20100918155143.tar.gz'
  homepage 'http://www.fossil-scm.org/'
  md5 'fca02199e1795114212eb588e2d9aa8c'

  def install
    system "make"
    bin.install 'fossil'
  end
end
