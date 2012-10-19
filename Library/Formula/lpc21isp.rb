require 'formula'

class Lpc21isp < Formula
  homepage 'http://lpc21isp.sourceforge.net/'
  url 'http://sourceforge.net/projects/lpc21isp/files/lpc21isp/1.83/lpc21isp_183.tar.gz'
  sha1 'b251105cec7a0a65f271c233c94e0fe3fab42082'
  version '1.83'

  def install
    # Can't statically link on OSX, so we'll remove that from the Makefile
    inreplace 'Makefile', "CFLAGS	+= -Wall -static", "CFLAGS	+= -Wall"
    system "make"
    bin.install ["lpc21isp"]
  end
end
