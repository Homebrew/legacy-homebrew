require 'brewkit'

class Pngcrush <Formula
  @homepage='http://pmt.sourceforge.net/pngcrush/'
  @url='http://downloads.sourceforge.net/sourceforge/pmt/pngcrush-1.7.0.tar.bz2'
  @md5='033f1542ef452952b1ba585cf21be70b'

  def install
    # use our CFLAGS and LDFLAGS thanks :P
    inreplace 'Makefile', 'CFLAGS = -I. -O3 -fomit-frame-pointer -Wall -Wshadow', ''
    inreplace 'Makefile', 'LDFLAGS =', ''

    system "make"
    bin.install 'pngcrush'
  end
end
