require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20121022124804.tar.gz'
  sha1 '9130ae9f17299b490e45dc25c20be81b140ea9cb'
  version '1.24'

  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "./configure"
    system "make"
    bin.install 'fossil'
  end
end
