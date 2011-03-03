require 'formula'

class Mkclean <Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.7.3.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkclean.html'
  md5 '22d7e5de7c52bc166f82632cde2967c1'

  def install
    system "./configure"
    system "make -C mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkclean"
  end
end
