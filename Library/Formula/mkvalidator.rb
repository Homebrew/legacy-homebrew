require 'formula'

class Mkvalidator < Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.3.3.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  md5 'f63cac5127e196e94ebdb0fe30ccf352'

  def install
    ENV.j1 # Otherwise there are races
    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end
