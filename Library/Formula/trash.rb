require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'http://github.com/hasseg/trash/archive/v0.8.3.zip'

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
