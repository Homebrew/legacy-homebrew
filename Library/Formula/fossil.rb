require 'formula'

class Fossil < Formula
  homepage 'http://www.fossil-scm.org/'
  url 'http://www.fossil-scm.org/download/fossil-src-20110301190432.tar.gz'
  sha1 '4332f6369332e118633c9a7f896b5cd3fd275217'
  head 'fossil://http://www.fossil-scm.org/'

  def install
    system "make"
    bin.install 'fossil'
  end
end
