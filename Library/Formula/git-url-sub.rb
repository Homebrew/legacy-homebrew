require 'formula'

class GitUrlSub < Formula
  homepage 'http://gosuri.github.io/git-url-sub'
  url 'https://github.com/gosuri/git-url-sub/archive/1.0.1.tar.gz'
  sha1 '294631d898a4263285f7a2ac0ce93ff494dadbf8'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
