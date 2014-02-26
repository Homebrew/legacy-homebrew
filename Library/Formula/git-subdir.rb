require "formula"

class GitSubdir < Formula
  homepage "https://github.com/andreyvit/git-subdir"
  url "https://github.com/andreyvit/git-subdir/archive/v0.1.tar.gz"
  sha1 "ac4128b74e8b6a6916d634e7313ee25d80afd579"

  depends_on 'git'
  def install
    system "make", "install" 
  end

  test do
    system "git init"
    system "git subdir"
  end
end
