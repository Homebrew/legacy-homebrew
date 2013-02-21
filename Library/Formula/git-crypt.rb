require 'formula'

class GitCrypt < Formula
  homepage 'http://www.agwa.name/projects/git-crypt/'
  url 'https://github.com/AGWA/git-crypt/archive/0.2.tar.gz'
  sha1 '683c4b7f520a3ad4c5b56c3fdf8ea6c9d4362f87'

  def install
    system "make"
    bin.install "git-crypt"
  end

  def test
    system "#{bin}/git-crypt"
  end
end
