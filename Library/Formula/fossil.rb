require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20100521162104.tar.gz'
  homepage 'http://www.fossil-scm.org/'
  md5 'a79cd18bf698013928fbafe7010f0b61'

  def install
    system "make"
    bin.install 'fossil'
  end
end
