require 'formula'

class Lpc21isp < Formula
  url 'http://sourceforge.net/projects/lpc21isp/files/lpc21isp/1.83/lpc21isp_183.tar.gz'
  version '1.83'
  homepage 'http://lpc21isp.sourceforge.net/'
  md5 '4b437a6d6e718afa6d182f0c18f5363f'

  def install
	
	# Can't statically link on OSX, so we'll remove that from the Makefile
	inreplace 'Makefile', "CFLAGS	+= -Wall -static", "CFLAGS	+= -Wall" 
    system "make"
    bin.install ["lpc21isp"]
  end
end
