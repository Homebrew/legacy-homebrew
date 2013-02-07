require 'formula'

class GitCrypt < Formula
  homepage 'http://www.agwa.name/projects/git-crypt/'
  url 'https://github.com/AGWA/git-crypt/tarball/0.2'
  sha1 '534e16316410abdf0623b50cbd1c98b4a0c0f0e6'

  def install
    system "make"
    bin.install "git-crypt"
  end

  def test
    system "git-crypt"
  end
end
