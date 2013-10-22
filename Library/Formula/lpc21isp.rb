require 'formula'

class Lpc21isp < Formula
  homepage 'http://lpc21isp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.94/lpc21isp_194.tar.gz'
  sha1 'e80a9a9518e7dc94d29ba43933a7985a0727b4da'
  version '1.94'

  def install
    # Can't statically link on OSX, so we'll remove that from the Makefile
    inreplace 'Makefile', "CFLAGS	+= -Wall -static", "CFLAGS	+= -Wall"
    system "make"
    bin.install ["lpc21isp"]
  end
end
