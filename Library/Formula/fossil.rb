require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20101207133137.tar.gz'
  head 'fossil://http://www.fossil-scm.org/'
  homepage 'http://www.fossil-scm.org/'
  md5 '3da8ef69f7865598edcfc48063f6f464'

  def install
    system "make"
    bin.install 'fossil'
  end
end
