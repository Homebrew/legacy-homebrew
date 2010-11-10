require 'formula'

class Fossil <Formula
  url 'http://www.fossil-scm.org/download/fossil-src-20101110014319.tar.gz'
  head 'fossil://http://www.fossil-scm.org/'
  homepage 'http://www.fossil-scm.org/'
  md5 '1d290490ecbebebc4875fc882b82498d'

  def install
    system "make"
    bin.install 'fossil'
  end
end
