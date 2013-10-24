require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20130618210923.tar.gz'
  sha1 'b8de07de92483ba491c7e11c1d82147bce1cdaf9'
  version '1.26'

  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
