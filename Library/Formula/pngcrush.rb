require 'brewkit'

class Pngcrush <Formula
  @homepage='http://pmt.sourceforge.net/pngcrush/'
  @url='http://downloads.sourceforge.net/sourceforge/pmt/pngcrush-1.6.19.tar.bz2'
  @md5='2cfe54e660e586a0302a6def1aa8b08e'

  def install
    # use our CFLAGS and LDFLAGS thanks :P
    inreplace 'Makefile', 'CFLAGS = -I. -O3 -fomit-frame-pointer -Wall -Wshadow', ''
    inreplace 'Makefile', 'LDFLAGS =', ''

    system "make"
    bin.install 'pngcrush'
  end
end
