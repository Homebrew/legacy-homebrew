require "formula"

class GitSubdir < Formula
  homepage "https://github.com/andreyvit/git-subdir"
  url "https://github.com/andreyvit/git-subdir/archive/v0.1.tar.gz"
  sha1 "849f55a310f76c523b911c02532700ecb3bca181"

  depends_on 'git'
  def install
    system "make", "install" 
  end

  test do
    system "git init"
    system "git subdir"
  end
end
