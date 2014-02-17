require "formula"

class GitSubdir < Formula
  homepage "https://github.com/andreyvit/git-subdir"
  url "git@github.com:andreyvit/git-subdir.git", :using => :git
  sha1 "ac4128b74e8b6a6916d634e7313ee25d80afd579"

  depends_on 'git'
  def install
    system "make", "install" 
  end

  test do
    system "git init && git subdir"
  end
end
