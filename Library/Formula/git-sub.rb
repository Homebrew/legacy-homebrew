require 'formula'

class GitSub < Formula
  homepage  'https://github.com/gosuri/git-sub'
  head      'git://github.com/gosuri/git-sub.git'
  url       'https://github.com/gosuri/git-sub/tarball/0.0.4'
  md5       'bc7d8be1c1afb517291282c905a41a7c'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
