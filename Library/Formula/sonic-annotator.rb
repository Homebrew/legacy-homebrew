require 'formula'

class SonicAnnotator < Formula
  homepage 'http://www.omras2.org/sonicannotator'
  url 'http://code.soundsoftware.ac.uk/attachments/download/700/sonic-annotator-1.0-osx-x86_64.tar.gz'
  sha1 '92a4d596f601fdf036fc280d2500036d63065644'
  version '1.0'

  def install
    bin.install 'sonic-annotator'
    doc.install 'README'
  end

  test do
    system "sonic-annotator"
  end
end
