require 'formula'

class Mkclean <Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.7.1.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkclean.html'
  md5 '57bbf26a937df688c570994711126bc0'

  def install
    system "./configure"
    system "make -C mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkclean"
  end
end
