require 'formula'

class Lpc21isp < Formula
  homepage 'http://lpc21isp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.92/lpc21isp_192.tar.gz'
  sha1 'e150757b2c91e5a760c6527011764bd7879732e8'
  version '1.92'

  def install
    # Can't statically link on OSX, so we'll remove that from the Makefile
    inreplace 'Makefile', "CFLAGS	+= -Wall -static", "CFLAGS	+= -Wall"
    system "make"
    bin.install ["lpc21isp"]
  end
end
