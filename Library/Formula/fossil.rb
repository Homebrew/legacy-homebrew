require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20101111133638.tar.gz'
  head 'fossil://http://www.fossil-scm.org/'
  homepage 'http://www.fossil-scm.org/'
  md5 '0393025ea0f5ca5ece7d632753123e77'

  def install
    system "make"
    bin.install 'fossil'
  end
end
