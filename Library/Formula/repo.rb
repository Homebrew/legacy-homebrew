require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.14'
  sha1 '29ba4221d4fccdfa8d87931cd73466fdc24040b5'
  version '1.14'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
