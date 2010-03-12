require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20100308141844.tar.gz'
  homepage 'http://www.fossil-scm.org/'
  md5 'ba555a2bb337bf7548169e39b4c84dab'

  def install
    system "make"
    bin.install 'fossil'
  end
end
