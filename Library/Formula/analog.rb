require 'formula'

class Analog < Formula
  url 'http://analog.cx/analog-6.0.tar.gz'
  homepage 'http://analog.cx'
  md5 '743d03a16eb8c8488205ae63cdb671cd'

  def install
    system "make"
    bin.install "analog"
    bin.install "analog.cfg"
    bin.install "lang"
    doc.install Dir["docs/*"]
    #not sure if this is the best way
    #to handle this man page
    cp "analog.man", "analog.1"
    man1.install "analog.1"
  end
end
