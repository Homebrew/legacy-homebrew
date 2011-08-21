require 'formula'

class GitHome < Formula
  url 'https://github.com/juanpabloaj/git-home/tarball/v0.1.1'
  homepage 'https://github.com/juanpabloaj/git-home'
  md5 'f9701cc0e0d75c908d6bbc18bbab9ade'
  def install
	  bin.install "git-home"
  end
end
