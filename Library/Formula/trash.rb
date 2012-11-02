require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'http://hasseg.org/git-public/trash.git/', :using => :git, :revision => '268d6f44ee4eb11a2052d8ded9a83a887dcd4ffc'
  version '0.8.2'

  def install
    system "make"
    system "make docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  def test
    system "trash"
  end
end
