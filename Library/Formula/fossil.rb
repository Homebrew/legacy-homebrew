require 'formula'

class Fossil <Formula
	
  @url='http://www.fossil-scm.org/download/fossil-src-20091220213451.tar.gz'
  @homepage='http://www.fossil-scm.org/'
  @md5='152d94b378eacc1d8151ec3385800ac2'

  def install
    system "make"
    bin.install 'fossil'
  end
end
