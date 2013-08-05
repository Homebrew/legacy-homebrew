require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'http://github.com/hasseg/trash/archive/v0.8.3.zip'
  sha1 'de3489f7dbfe03dc490a3c7da22dba90998af3d1'

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
