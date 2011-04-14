require 'formula'

class Mkclean < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.2.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkclean.html'
  md5 '3d2976101ed8fa7cacc2986bfbf20ce5'

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make -C mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkclean"
  end
end
