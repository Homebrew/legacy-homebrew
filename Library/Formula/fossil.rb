require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20100805100943.tar.gz'
  homepage 'http://www.fossil-scm.org/'
  md5 '33c2cf512c72f5b153dbfc26867e16ed'

  def install
    system "make"
    bin.install 'fossil'
  end
end
