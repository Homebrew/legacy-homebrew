require 'formula'

class GitSh < Formula
  homepage 'https://github.com/rtomayko/git-sh'
  url 'https://github.com/rtomayko/git-sh/archive/1.3.tar.gz'
  sha1 'b96801ed2a63ef510583e7f1c1b4bc234d991507'

  head 'https://github.com/rtomayko/git-sh.git'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
