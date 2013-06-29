require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.19'
  version '1.19'
  sha1 'e48d46e36194859fe8565e8cbdf4c5d1d8768ef3'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
