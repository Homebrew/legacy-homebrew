require 'brewkit'

class Pngcrush <Formula
  @homepage='http://pmt.sourceforge.net/pngcrush/'
  @url='http://kent.dl.sourceforge.net/sourceforge/pmt/pngcrush-1.6.17.tar.bz2'
  @md5='8ba31ae9b1b14e7648df320fd1ed27c7'

  def install
    system "make"
    bin.install 'pngcrush'
  end
end