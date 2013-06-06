require 'formula'

class Lpc21isp < Formula
  homepage 'http://lpc21isp.sourceforge.net/'
  url 'http://sourceforge.net/projects/lpc21isp/files/lpc21isp/1.85/lpc21isp_185.tar.gz'
  sha1 '5548874c88b0b34c253e12a36f3df04c8768309e'
  version '1.85'

  def install
    # Can't statically link on OSX, so we'll remove that from the Makefile
    inreplace 'Makefile', "CFLAGS	+= -Wall -static", "CFLAGS	+= -Wall"
    system "make"
    bin.install ["lpc21isp"]
  end
end
