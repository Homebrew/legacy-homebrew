require 'brewkit'

class Fossil <Formula
  @url='http://www.fossil-scm.org/download/fossil-src-20090914165629.tar.gz'
  @homepage='http://www.fossil-scm.org/'
  @md5='79b18158e77175ab505d5157fece89fd'

  def install
    system "make"
    bin.install 'fossil'
  end
end
