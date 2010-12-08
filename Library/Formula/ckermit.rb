require 'formula'

class Ckermit <Formula
  url 'ftp://kermit.columbia.edu/kermit/archives/cku211.tar.gz'
  homepage 'http://ftp.nluug.nl/networking/kermit/public_html/ckermit.html'
  md5 '5767ec5e6ff0857cbfe2d3ec1ee0e2bc'

  def install
    system "make macosx103"
    system "mv wermit kermit"
    bin.install "kermit"
  end
end
