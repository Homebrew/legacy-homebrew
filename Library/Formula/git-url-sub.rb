require 'formula'

class GitUrlSub < Formula
  url       'https://github.com/gosuri/git-url-sub/tarball/1.0.1'
  homepage  'http://gosuri.github.com/git-url-sub'
  md5       '5d2dad29dcd53eedc0730f42014bec51'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
