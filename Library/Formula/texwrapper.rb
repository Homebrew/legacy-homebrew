require 'formula'

class Texwrapper < Formula
  homepage 'http://obrecht.fr/texwrapper/'
  url 'http://obrecht.fr/texwrapper/texwrapper.0.2.2.tar.gz'
  sha1 '692c157f6f8b6ea1fc8bc4720d287ab147690fcc'

  def install
    system "make"
    bin.install 'texwrapper'
    man1.install 'texwrapper.1'
  end
end
