require 'formula'

class GitSh < Formula
  homepage 'https://github.com/rtomayko/git-sh'
  url 'https://github.com/rtomayko/git-sh/tarball/bd044dfd33513665a75aa89467e1a6e9e04cb3d6'
  version '201301241'
  sha1 'a2b071417167a18d751c66236986086c7a21d43d'

  head 'https://github.com/rtomayko/git-sh.git'

  # Pending request for new tag:
  # https://github.com/rtomayko/git-sh/issues/16

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
