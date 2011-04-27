require 'formula'

class Fossil < Formula
  version '047e06193b'
  url 'http://www.fossil-scm.org/download/fossil-src-20110413120518.tar.gz'
  md5 'a044c50bf9f097db6630a409fc2f90bd'
  homepage 'http://www.fossil-scm.org/'
  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "make"
    bin.install 'fossil'
  end
end
