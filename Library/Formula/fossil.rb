require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20110208125237.tar.gz'
  head 'fossil://http://www.fossil-scm.org/'
  homepage 'http://www.fossil-scm.org/'
  md5 '274c1cf4db0d57b5af9a86b3bb74c63e'

  def install
    system "make"
    bin.install 'fossil'
  end
end
