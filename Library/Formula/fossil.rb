require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20120808112557.tar.gz'
  sha1 'b7c3f0092ac9a00e71675464c0f3c7f0297df25f'
  version '1.23'

  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
