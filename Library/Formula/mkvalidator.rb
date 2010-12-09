require 'formula'

class Mkvalidator <Formula
  url 'http://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.3.1.tar.bz2'
  homepage 'http://www.matroska.org/downloads/mkvalidator.html'
  md5 'd767ed6fbda281c07f27a190cad1a1c4'

  def install
    system "./configure"
    system "make -C mkvalidator"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install "release/#{bindir}/mkvalidator"
  end
end
