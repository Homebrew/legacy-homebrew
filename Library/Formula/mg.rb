require 'formula'

class Mg < Formula
  homepage 'http://homepage.boetes.org/software/mg/'
  url 'http://homepage.boetes.org/software/mg/mg-20131118.tar.gz'
  sha1 '61f0d6ef2fd36acc51fa560aa67d4eccd3a6c2b9'

  depends_on 'clens'

  def install
    system "make"
    bin.install "mg"
    doc.install "tutorial"
    man1.install "mg.1"
  end
end
