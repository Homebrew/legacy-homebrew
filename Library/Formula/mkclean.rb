require 'formula'

class Mkclean < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.0.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkclean.html'
  md5 '8844bf8d00b55790be9ea6d45cc38bda'

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make -C mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkclean"
  end
end
