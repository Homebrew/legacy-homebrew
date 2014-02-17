require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'http://github.com/ali-rantakari/trash/archive/v0.8.4.zip'
  sha1 '233773bcaed903e296f20635808c3dce7ef93c4b'

  conflicts_with 'osxutils', :because => 'both install a trash binary'

  def install
    system "make"
    system "make docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  def test
    system "#{bin}/trash"
  end
end
