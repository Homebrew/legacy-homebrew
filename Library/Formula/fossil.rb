require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20100703153359.tar.gz'
  homepage 'http://www.fossil-scm.org/'
  md5 '2f9d5d3587a902896b31a6bd1855f386'

  def install
    system "make"
    bin.install 'fossil'
  end
end
