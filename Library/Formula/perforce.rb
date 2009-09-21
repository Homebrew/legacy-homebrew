require 'brewkit'

class Perforce <Formula
  @url='http://filehost.perforce.com/perforce/r09.1/bin.macosx104u/p4'
  @homepage='http://www.perforce.com/'
  @md5='460d7604a2126bd63d6e202238ec58ef'
  @version='2009.1.211694'

  def install
    bin.install 'p4'
  end
end
