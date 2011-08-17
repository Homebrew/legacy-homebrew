require 'formula'

class GitHome < Formula
  url 'https://github.com/juanpabloaj/git-home/tarball/v0.1'
  homepage 'https://github.com/juanpabloaj/git-home'
  md5 '3e5ab7b6516e33660c404e75a9d81d82'
  def install
	  bin.install "git-home"
  end
end
