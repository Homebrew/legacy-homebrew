require 'formula'

class GitDiffall < Formula
  url 'https://github.com/thenigan/git-diffall/tarball/ac986bb784873044e81a4b5e0a6353793bed8acc'
  version 'ac986bb784873044e81a4b5e0a6353793bed8acc'
  homepage 'https://github.com/thenigan/git-diffall'
  md5 '5610232d3b014c55ed964537917f79ee'

  def install
    bin.install('git-diffall')
  end

  def test
    system "test -x /usr/local/bin/git-diffall"
  end
end
