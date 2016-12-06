require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'http://hasseg.org/git-public/trash.git/', :using => :git, :tag => 'v0.8.2'
  version '0.8.2'

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
