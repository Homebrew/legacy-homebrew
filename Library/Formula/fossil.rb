require 'formula'

class Fossil <Formula
  @url='http://www.fossil-scm.org/download/fossil-src-20091111162119.tar.gz'
  @homepage='http://www.fossil-scm.org/'
  @md5='7522d1ad59387032cb5d4dec203d1afa'

  def install
    system "make"
    bin.install 'fossil'
  end
end
